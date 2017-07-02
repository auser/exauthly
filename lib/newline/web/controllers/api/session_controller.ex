defmodule Newline.Web.SessionController do
  use Newline.Web, :controller

  alias Newline.Accounts
  alias Newline.Accounts.{User}

  action_fallback Newline.Web.FallbackController

  def index(conn, _params) do
    changeset = User.user_changeset(%User{}, %{})
    IO.inspect changeset
    render conn, "login.html", changeset: changeset
  end

  def create(conn, params) do
    params = params["user"]
    case Accounts.user_login(params) do
      {:error, reason} ->
        conn
        |> put_status(400)
        |> render("error.html", error: reason)
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.html")
    end
  end

  # def create(conn, params) do
  #   with {:ok, user} <- Accounts.authenticate(params) do
  #     new_conn = Accounts.sign_in_user(:api, conn, user)
  #     jwt = Accounts.get_current_token(new_conn)

  #     new_conn
  #     |> put_status(:created)
  #     |> render("show.json", user: user, jwt: jwt)
  #   end
  # end

  def delete(conn, _) do
    with jwt = Accounts.get_current_token(conn),
         Accounts.revoke_token!(jwt) do
      conn
      |> put_status(:ok)
      |> render("delete.json")
    end
  end

  def refresh(conn, _params) do
    user = Accounts.get_current_user(conn)
    with jwt = Accounts.get_current_token(conn),
         {:ok, claims} <- Accounts.get_claims(conn),
         {:ok, new_jwt, _new_claims} <- Accounts.refresh_token!(jwt, claims) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user, jwt: new_jwt)
    end
  end
end
