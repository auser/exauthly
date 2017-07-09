defmodule Newline.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """
  alias Newline.Repo
  import Ecto.{Query, Changeset}, warn: false
  alias Ecto.Multi

  alias Newline.Accounts.{User,SocialAccount,Organization}
  alias Newline.Email

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(user, %{field: value})
      {:ok, %User{}}

      iex> create_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    changeset = User.registration_changeset(%User{}, attrs)

    case Repo.transaction(run_insert(changeset)) do
      {:error, _failed_op, failed_cs, _changes} ->
        {:error, failed_cs}
      {:ok, %{user: user}} ->
        {:ok, jwt, _claims} = sign_in_user(:token, user)
        {:ok, Map.put(user, :token, jwt)}
      other ->
        IO.puts "HUh? #{inspect(other)}"
    end
  end

  @doc """
  Login the user by params

  ## Examples

      iex> user_login(%{"email" => "ari@fullstack.io", "password" => "abc123"})
  """
  def user_login(params, login_claims \\ %{}) do
    case authenticate(params) do
      {:error, reason} -> {:error, reason}
      {:ok, user} ->
        {:ok, jwt, _claims} = sign_in_user(:token, user, login_claims)
        {:ok, Map.put(user, :token, jwt)}
    end
  end

  def user_social_login(params, login_claims \\ %{}) do
    case social_authentication(params) do
      {:error, reason} -> {:error, reason}
      {:ok, user} ->
        {:ok, jwt, _claims} = sign_in_user(:token, user, login_claims)
        {:ok, Map.put(user, :token, jwt)}
    end
  end


  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    changeset = User.user_changeset(user, attrs)
    case Repo.transaction(run_update(changeset)) do
      {:error, _failed_op, failed_cs, _changes} ->
        {:error, failed_cs}
      {:ok, %{user: user}} ->
        {:ok, user}
    end
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Verify a user's email

  ## Examples

      iex> verify_user(user)
      {:ok, %User{}}
      iex> verify_user(user)
      {:error, :not_found}
  """
  def verify_user(token) do
    case user_by_verify_token(token) do
      nil -> {:error, :not_found}
      %User{} = user ->
        cs = User.verifying_changeset(user, %{verify_token: token})
        Repo.update(cs)
    end
  end

  @doc """
  Change a user's password request

  ## Examples

      iex> request_user_password_reset("ari@fullstack.io")
  """
  def request_user_password_reset(email) do
    case Repo.get_by(User, email: String.downcase(email)) do
      nil -> {:error, false}
      user ->
        changeset = User.reset_password_request_changeset(user)
        case Repo.transaction(run_update_password(changeset)) do
          {:error, _failed_op, failed_cs, _changes} ->
            {:error, failed_cs}
          {:ok, %{user: user}} ->
            {:ok, user}
        end
    end
  end

  @doc """
  args: provider, user, params
  Chooses create or update for the user
  """
  def user_link_and_signup(provider, nil, params) do
    # user_changeset = %User{} |> User.registration_changeset(params)
    case Repo.transaction(user_link_and_signup_social_changeset(provider, params)) do
      {:error, _failed_op, cs, _changes} ->
        IO.inspect cs
        {:error, cs}
      {:ok, %{social_account: social_account}} ->
        {:ok, social_account}
    end
  end
  def user_link_and_signup(provider, user_id, params) do
    case Repo.get(User, user_id) do
      {:error, _reason} ->
        {:error, "User does not exist"}
      user ->
        associate_social_account(provider, user, params)
    end
  end

  @doc """
  Associate a social account to the user
  """
  def associate_social_account(provider, user, params) do
    params = params
      |> Map.put("social_account_name", provider)
      |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
      |> Enum.into(%{})

    cs = user |> User.social_account_changeset(params)
    case Repo.transaction(run_associate_account(cs)) do
      {:error, _op, failed_cs, _changes} ->
        {:error, failed_cs}
      {:ok, %{social_account: social_account}} ->
        {:ok, social_account}
    end
  end

  @doc """
  Disassociate a social account with a user
  """
  def disassociate_social_account(provider, user, id) do
    query = from sa in SocialAccount,
            where: sa.id == ^"#{id}"
            and sa.user_id == ^user.id
            and sa.social_account_name == ^provider,
            select: sa

    case Repo.one(query) do
      nil ->
        {:error, :not_found}
      sa ->
        Repo.delete(sa)
    end
  end

  @doc """
  Get the social account id
  """
  def get_social_account(user, name) when is_atom(name), do: get_social_account(user, to_string(name))
  def get_social_account(user, name) do
    query = from sa in SocialAccount,
            where: sa.social_account_name == ^name
                   and sa.user_id == ^user.id

    case Repo.one(query) do
      nil ->
        {:error, :not_found}
      sa ->
        {:ok, sa}
    end
  end

  @doc """
  Set the current organization for the user
  """
  def set_current_organization(%User{} = user, %Organization{} = org) do
    User.current_organization_changeset(user, %{
      current_organization_id: org.id
    })
    |> Repo.update
  end
  def set_current_organization(_, _), do: {:error, :bad_request}

  #####################################

  defp run_update_password(changeset) do
    Multi.new
    |> Multi.update(:user, changeset)
    |> Multi.run(:send_update, &(send_password_reset_request_email(&1[:user])))
  end

  @doc """
  Reset a user's password based on their token
  """
  def reset_password(token, password) do
    case user_by_password_token(token) do
      nil ->
        {:error, :not_found}
      user = %User{} ->
        user
        |> User.reset_password_changeset(%{password: password})
        |> Repo.update!()
        |> send_password_reset_email()
        {:ok, jwt, claims} = sign_in_user(:token, user)
        {:ok, %{user: user, token: jwt, claims: claims}}
    end
  end

  def send_password_reset_request_email(user) do
    {:ok, Email.send_password_reset_request_email(user)}
  end

  defp send_password_reset_email(user) do
    {:ok, Email.send_password_reset_email(user)}
  end

  def send_welcome_email(user) do
    {:ok, Email.send_welcome_email(user)}
  end

  @doc """
  Get a user by their password_reset_token

  ## Examples

      iex> user_by_password_token("token")
  """
  def user_by_password_token(token) do
    query = from u in User,
            where: u.password_reset_token == ^token
            and u.password_reset_timestamp > fragment("now() - interval '48hours'"),
            select: u
    Repo.one(query)
  end

  @doc """
  Get a user by the verify token

  ## Examples

      iex> user_by_verify_token(token)
  """
  def user_by_verify_token(nil), do: nil
  def user_by_verify_token(token) do
    query = from u in User,
            where: u.verify_token == ^token,
            select: u
    Repo.one(query)
  end

  @doc """
  Check if the email has already been taken

  ## Examples

      iex> check_email_availability("ari@fullstack.io")
  """
  def check_email_availability(email) do
    check_valid_email(email) and check_taken(:email, email)
  end

  @doc """
  Get the current token associated with a connection
  """
  def get_current_token(conn) do
    Guardian.Plug.current_token(conn)
  end

  def revoke_token!(jwt) do
    Guardian.revoke!(jwt)
  end

  def get_claims(conn) do
    Guardian.Plug.claims(conn)
  end

  def refresh_token!(jwt, claims) do
    Guardian.refresh!(jwt, claims, %{ttl: {30, :days}})
  end

  def get_current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  @doc """
  Sign in a user
  """
  def sign_in_user(type, conn, claims \\ %{})
  def sign_in_user(:api, conn, user) do
    Guardian.Plug.api_sign_in(conn, user, :access)
  end

  @doc """
  Authenticate user
  """
  def sign_in_user(:token, user, login_claims) do
    Guardian.encode_and_sign(user, :access, login_claims)
  end

  @doc """
  Authenticate a user by email and password
  """
  def authenticate(%{email: email, password: password}), do: authenticate(%{"email" => email, "password" => password})
  def authenticate(%{"email" => email, "password" => password}) do
    user = Repo.get_by(Newline.Accounts.User, email: String.downcase(email))

    case check_password(user, password) do
      true -> {:ok, user}
      _ ->
        {:error, "Your password does not match with the password we have on record"}
    end
  end

  @doc """
  Social authentication
  """
  def social_authentication(%{social_account_name: name, social_account_id: user_id}) do
    query = from sa in SocialAccount,
            where: sa.social_account_id == ^user_id and
                   sa.social_account_name == ^name,
            preload: [:user]
    case Repo.one(query) do
      nil -> {:error, "Invalid token"}
      account ->
        {:ok, account.user}
    end
  end

  # Insert for new user
  defp run_insert(changeset) do
    Multi.new
    |> Multi.insert(:user, changeset)
    |> Multi.run(:send_welcome_email, &(send_welcome_email(&1[:user])))
  end

  # Update for existing user
  defp run_update(changeset) do
    Multi.new
    |> Multi.update(:user, changeset)
  end

  defp run_associate_account(changeset) do
    Multi.new
    |> Multi.insert(:social_account, changeset)
  end

  ## Helpers

  defp check_valid_email(email) do
    String.match?(email, ~r/@/)
  end

  # Check if a field is taken
  defp check_taken(column, val) do
    User
    |> where([u], field(u, ^column) == ^val)
    |> Repo.all
    |> Enum.empty?
  end

  defp check_password(user, password) do
    case user do
      nil -> Comeonin.Bcrypt.dummy_checkpw()
      _ -> Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
    end
  end

  defp social_params(provider, params) do
    params
      |> Map.put("social_account_name", provider)
      |> Map.put("social_account_id", params["social_account_id"])
  end

  # TODO: MOVE ME DOWN BELOW
  defp user_link_and_signup_social_changeset(provider, params) do
    Multi.new
    |> Multi.insert(:user, User.social_registration_changeset(%User{}, params))
    # |> Multi.insert(:social_account, social_params(provider, params))
    |> Multi.insert(:social_account, SocialAccount.changeset(%SocialAccount{}, params))
    |> Multi.run(:associate_social_account, &(associate_social_account(provider, &1[:user], params)))
  end

end
