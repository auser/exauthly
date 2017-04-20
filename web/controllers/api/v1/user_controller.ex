defmodule Newline.V1.UserController do
  use Newline.Web, :controller
  alias Newline.{UserService}

  @doc """
  Signup a new user
  """
  def create(conn, params = %{"email" => _, "password" => _}) do
    res = UserService.user_signup(params)
    case res do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(Newline.UserView, "show.json", user: user)

      {:error, cs} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Newline.UserView, "error.json", changeset: cs)
    end
  end
  def create(conn, _), do: invalid_params(conn)

  @doc """
  Request a password reset
  """
  def request_password_reset(conn, %{"email" => email}) do
    case UserService.request_password_reset(email) do
      {:ok, _user} ->
        conn
        |> send_resp(200, "ok")
      {:error, _reason} ->
        conn
        |> put_status(:not_found)
        |> render(Newline.ErrorView, "error.json", errors: ["user does not exist"])
    end
  end
  def request_password_reset(conn, _), do: invalid_params(conn)

  @doc """
  Reset the user's password based on token""'
  """
  def password_reset(conn, %{"token" => token, "password" => password}) do
    case UserService.password_reset(token, password) do
      {:ok, user, jwt, _claims} ->
        conn
        |> put_status(:ok)
        |> render(Newline.SessionView, "show.json", user_id: user.id, token: jwt)
      {:error, _reason} ->
        conn
        |> put_status(:bad_request)
        |> render(Newline.UserView, "error.json", errors: ["invalid or expired token"])
    end
  end

  defp invalid_params(conn) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Newline.UserView, "error.json", message: "Invalid params")
  end

end