defmodule Newline.UserService do
  use Newline.Web, :service
  alias Newline.{Email, Mailer, Repo, User}

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
  Send a welcome email to a new user
  """
  def send_welcome_email(_params, user) do
    user
    |> Email.welcome_email
    |> Mailer.deliver_later
    {:ok, user}
  end

  def send_password_reset_request_email(user) do
    user
    |> Email.password_reset_request_email
    |> Mailer.deliver_later
  end

end