defmodule Newline.UserService do
  @moduledoc """
  A module to provide handlingn underlying business logic
  for handling anything to do with users.
  """
  use Newline.Web, :service
  alias Newline.{Email, Mailer, Repo, User}

  @doc """
  Handle user signup
  """
  def user_signup(params) do
    changeset = User.signup_changeset(%User{}, params)

    result = 
      insert(changeset, params)
      |> Repo.transaction()

    case result do
      {:ok, %{user: user}} ->
        {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)
        {:ok, Map.put(user, :token, jwt)}
      {:error, _failed_op, changeset, _changes} ->      
        {:error, changeset}
    end
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
  def password_reset(token, password) do
    case user_by_password_token(token) do
      nil -> {:error, :not_found}
      user = %User{} ->
        user
        |> User.reset_password_changeset(%{password: password})
        |> Repo.update!
        |> send_password_reset_email
        {:ok, user}
    end
  end

  defp user_by_password_token(token) do
    query = from u in User,
            where: u.password_reset_token == ^token
            and u.password_reset_timestamp > fragment("now() - interval '48hours'"),
            select: u
    Repo.one(query)
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

end