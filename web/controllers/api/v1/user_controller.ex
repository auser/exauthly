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

  defp invalid_params(conn) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Newline.UserView, "error.json", message: "Invalid params")
  end

end