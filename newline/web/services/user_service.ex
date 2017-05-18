defmodule Newline.UserService do
  import Newline.BasePolicy, only: [site_admin?: 1]

  @moduledoc """
  A module to provide handlingn underlying business logic
  for handling anything to do with users.
  """
  use Newline.Web, :service
  alias Newline.{Email, Mailer, Repo, User, OrganizationMembership}

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
  Authenticate user
  """
  def do_user_login(user, login_claims \\ %{}) do
    this_user_claims = user_claims(user, login_claims)
    user |> Guardian.encode_and_sign(:access, this_user_claims)
  end

  # Assign user claims with admin
  defp user_claims(user, login_claims \\ %{}) do
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
    |> Multi.run(:send_welcome_email, &(send_welcome_email(params, &1[:user])))
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
  def request_password_reset(email) do
    case Repo.get_by(User, email: String.downcase(email)) do
      nil -> {:error, :not_found}
      user ->
        user
        |> User.reset_password_request_changeset
        |> Repo.update!
        |> send_password_reset_request_email
        {:ok, user}
    end
  end

  @doc """
  Reset a user's password'
  """
  def reset_password(token, password) do
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

  defp user_by_password_token(token) do
    query = from u in User,
            where: u.password_reset_token == ^token
            and u.password_reset_timestamp > fragment("now() - interval '48hours'"),
            preload: [:organizations],
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
  def user_memberships(user) do
    # organization_query = from org in "organizations",
                            # preload:
    membership_query = from m in OrganizationMembership,
                        where: m.member_id == ^user.id,
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
