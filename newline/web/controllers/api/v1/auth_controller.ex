defmodule Newline.V1.AuthController do
  use Newline.Web, :controller
  plug Ueberauth

  alias Newline.{UserService, UserAuthService}

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, _) do
    conn
    |> put_status(:unauthorized)
    |> render(Newline.SessionView, "401.json", message: hd(fails.errors).message)
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _) do
    case UserAuthService.get_or_insert(auth) do
      {:ok, user} ->
        {:ok, user, jwt, _claims} = UserService.do_user_login(user)
        conn
        |> put_status(:created)
        |> render(Newline.SessionView, "show.json", token: jwt, user_id: user.id)
      {:error, reason} -> 
        conn
        |> put_status(:unauthorized)
        |> render(Newline.SessionView, "401.json", message: reason)
    end
  end
end