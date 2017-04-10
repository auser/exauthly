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
end