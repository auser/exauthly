defmodule Newline.V1.UserController do
  use Newline.Web, :controller
  alias Newline.{UserService}

  def create(conn, params = %{"email" => _, "password" => _}) do
    case UserService.user_signup(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(Newline.UserView, "show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Newline.UserView, "error.json", changeset: changeset)
    end
  end

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

end