defmodule Newline.UserService do
  import Newline.BasePolicy, only: [site_admin?: 1]
  import Canada, only: [can?: 2]

  @moduledoc """
  A module to provide handlingn underlying business logic
  for handling anything to do with users.
  """
  use Newline.Web, :service
  alias Newline.{Email, Mailer, Repo, User, OrganizationMembership, OrganizationService, StripePlatformCustomer}

  @doc """
  Handle user signup
  """
  def user_signup(params) do
    changeset = User.signup_changeset(%User{}, params)

    case Repo.transaction(insert(changeset, params)) do
      {:ok, %{user: user}} ->
        {:ok, jwt, _claims} = do_user_login(user)
        {:ok, Map.put(user, :token, jwt)}
      {:error, _failed_op, failed_changeset, _changes} ->
        {:error, failed_changeset}
    end
  end

  @doc """
  Handle user login
  """
  def user_login(params, login_claims \\ %{}) do
    case  User.authenticate_by_email_and_pass(params) do
      {:ok, user} ->
        {:ok, jwt, _claims} = do_user_login(user, login_claims)
        {:ok, Map.put(user, :token, jwt)}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Check if the email has been taken
  """
  def check_email_availability(email) do
    check_valid_email(email) and check_taken(:email, email)
  end

  @doc """
  Get the details about the current user
  """
  def get_me(user) do
    case can?(user, read user) do
      true -> user_profile(user)
      false -> Newline.BaseResolver.unauthorized_error
    end
  end

  @doc """
  Get all the users for a particular query

  A user can see _all_ the users of an organization if they are 
  the owner or the administrator of the group. They can also see all the
  members for _every_ group when there is no current organization _and_ they
  are marked as a global administrator.

  A user without a role cannot list anything
  """
  def get_all(_args, %{context: %{current_user: _, current_org: nil, admin: true}}) do
    {:ok, Repo.all(User)}
  end
  def get_all(_, %{context: %{role: nil}}), do: Newline.BaseService.unauthorized_error
  def get_all(_args, %{context: %{current_user: user, current_org: org}}) do
    case can?(user, read org) do
      true -> 
        members = OrganizationService.get_members(org) |> Enum.reduce([], fn(m, acc) -> [Map.put(m.member, :membership_role, m.role)|acc] end)
        {:ok, members}
      false -> Newline.BaseService.unauthorized_error
    end
  end
  def get_all(_, _), do: Newline.BaseService.unauthorized_error

  @doc """
  Authenticate user
  """
  def do_user_login(user, login_claims \\ %{}) do
    this_user_claims = user_claims(user, login_claims)
    user |> Guardian.encode_and_sign(:access, this_user_claims)
  end

  # Assign user claims with admin
  defp user_claims(user, login_claims) do
    perms = case site_admin?(user) do
      true -> Map.merge(%{ default: [:read, :write], admin: Guardian.Permissions.max }, login_claims)
      false -> Map.merge(%{ default: [:read, :write] }, login_claims)
    end
    Guardian.Claims.app_claims
        |> Map.put(:perms, perms)
        |> Guardian.Claims.ttl({30, :days})
  end

  @doc """
  insert a user by changeset
  """
  def insert(changeset, params \\ %{}) do
    Multi.new
    |> Multi.insert(:user, changeset)
    |> Multi.run(:create_default_group, &(create_default_group(params, &1[:user])))
    |> Multi.run(:send_welcome_email, &(send_welcome_email(params, &1[:user])))
  end

  @doc """
  Update a User record and any associated `StripePlatformCustomers` records.

  These related records inherit the email field from the user,
  so they need to be kept in sync, both locally, and on the Stripe platform.
  """
  def update(%User{} = user, params) do
    changeset = user |> User.update_changeset(params)
    do_update(changeset)
  end

  # handle updates
  defp do_update(%Changeset{changes: %{email: _email}} = changeset) do
    multi = Multi.new
        |> Multi.update(:update_user, changeset)
        |> Multi.run(:update_platform_customer, &update_platform_customer/1)
    
    case Repo.transaction(multi) do
      {:ok, %{
        update_user: user,
        update_platform_customer: update_platform_customer_result }} ->
          {:ok, 
            user, 
            update_platform_customer_result }
        {:error, :update_user, %Ecto.Changeset{} = changeset, %{}} -> 
          {:error, changeset}
        {:error, _op, _val, _changes} -> 
          {:error, :unhandled}
    end
  end

  defp do_update(%Changeset{} = changeset) do
    with {:ok, user} <- Repo.update(changeset) do
      {:ok, user, nil, nil}
    else
      {:error, changeset} -> {:error, changeset}
      _ -> {:error, :unhandled}
    end
  end

  defp update_platform_customer(%{update_user: %User{id: user_id, email: email}}) do
    StripePlatformCustomer
    |> Repo.get_by(user_id: user_id)
    |> do_update_platform_customer(%{email: email})
  end
  defp do_update_platform_customer(nil, _), do: {:ok, nil}
  defp do_update_platform_customer(%StripePlatformCustomer{} = stripe_platform_customer, attributes) do
    {:ok, %StripePlatformCustomer{} = platform_customer, _} =
      StripePlatformCustomerService.update(stripe_platform_customer, attributes)

    {:ok, platform_customer}
  end

  @doc """
  Change a user's password'
  """
  def change_password(current_user, %{"old_password" => old_pass, "new_password" => new_pass}) do
    if User.check_user_password(current_user, old_pass) do
      User.change_password_changeset(current_user, %{password: new_pass})
      |> Repo.update
    else
      {:error, :bad_password}
    end
  end

  @doc """
  Request a new password
  """
  def request_password_reset(email), do: do_request_password_reset(email)

  defp do_request_password_reset(email) do
    case Repo.get_by(User, email: String.downcase(email)) do
      nil -> {:error, false}
      user ->
        user
        |> User.reset_password_request_changeset
        |> Repo.update!
        |> send_password_reset_request_email
        {:ok, true}
    end
  end

  @doc """
  Reset a user's password'
  """
  def reset_password(token, password), do: do_reset_password(token, password)

  defp do_reset_password(token, password) do
    case user_by_password_token(token) do
      nil -> {:error, :not_found}
      user = %User{} ->
        user
        |> User.reset_password_changeset(%{password: password})
        |> Repo.update!
        |> send_password_reset_email
        {:ok, jwt, claims} = do_user_login(user)
        {:ok, user, jwt, claims}
    end
  end

  defp check_valid_email(email) do
    String.match?(email, ~r/@/)
  end

  defp check_taken(column, val) do
    User
    |> where([u], field(u, ^column) == ^val)
    |> Repo.all
    |> Enum.empty?
  end

  defp user_by_password_token(token) do
    query = from u in User,
            where: u.password_reset_token == ^token
            and u.password_reset_timestamp > fragment("now() - interval '48hours'"),
            preload: [:organizations],
            select: u
    Repo.one(query)
  end

  @doc """
  Verify a user
  """
  def verify_user(token) do
    case user_by_verify_token(token) do
      nil -> {:error, :not_found}
      user = %User{} ->
        user = user
        |> User.verifying_changeset(%{verify_token: token})
        |> Repo.update!
        {:ok, jwt, _claims} = do_user_login(user)
        user = Map.put(user, :token, jwt)
        {:ok, user}
    end
  end

  defp user_by_verify_token(token) do
    query = from u in User,
            where: u.verify_token == ^token,
            select: u
    Repo.one(query)
  end

  @doc """
  User profile
  """
  def user_profile(user) do
    {:ok, user}
  end

  @doc """
  Create a group for the user
  """
  def create_default_group(_params, user) do
    org = OrganizationService.create_org(user, %{name: user.name})
    {:ok, org}
  end

  @doc """
  Send a welcome email to a new user
  """
  def send_welcome_email(_params, user) do
    user
    |> Email.welcome_email
    |> Mailer.deliver_later
    {:ok, user}
  end

  @doc """
  Send a password reset request email
  """
  def send_password_reset_request_email(user) do
    user
    |> Email.password_reset_request_email
    |> Mailer.deliver_later
  end

  @doc """
  Send a password reset email
  """
  def send_password_reset_email(user) do
    user
    |> Email.password_reset_email
    |> Mailer.deliver_later
  end

  @doc """
  Get user memberships
  """
  def user_memberships(%User{id: user_id}), do: user_memberships(user_id)
  def user_memberships(user_id) do
    # organization_query = from org in "organizations",
                            # preload:
    membership_query = from m in OrganizationMembership,
                        where: m.member_id == ^user_id,
                        left_join: org in assoc(m, :organization),
                        left_join: member in assoc(m, :member),
                        preload: [organization: org, member: member]
                        # select: [%{id: m.id, role: m.role, org: org}]
    Repo.all(membership_query)
  end

  @doc """
  Get user and organizations
  """
  def user_with_organizations(user) do
    user = Repo.get(User, user.id)
    |> Repo.preload([:organizations, :organization_memberships, :current_organization])
    %{organizations: user.organizations, current_organization: user.current_organization}
  end

end
