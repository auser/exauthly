defmodule Newline.Web.UserController do
  use Newline.Web, :controller

  alias Newline.Accounts
  alias Newline.Accounts.User

  action_fallback Newline.Web.FallbackController

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      new_conn = Accounts.sign_in_user(:api, conn, user)
      jwt = Accounts.get_current_token(new_conn)

      new_conn
      |> put_status(:created)
      |> render(Newline.Web.SessionView, "show.json", user: user, jwt: jwt)
    end
  end
end
