defmodule Newline.Web.AuthController do
  @moduledoc """
  Auth controller
  """

  use Newline.Web, :controller
  alias Newline.Accounts
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_status(200)
    |> Guardian.Plug.sign_out(conn)
  end



  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate")
    |> put_status(401)
    |> redirect(to: "/login")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider} = _params) do
    IO.inspect auth

    case Accounts.social_user_link_and_signup(provider, auth) do
      {:ok, social_account} ->
        {:ok, user} = Accounts.user_social_login(social_account)
        # redirect_to = %{auth_token: social_account.auth_token}
        # |> URI.encode_query
        # IO.inspect redirect_to
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/")
      _ ->
        conn
        |> redirect(to: "/")
    end
    # cs = Accounts.user_link_and_signup(params)
    # IO.inspect cs
      # {:ok, account} ->
        # IO.inspect account
        conn
        |> redirect(to: "/")
      # {:error, err} ->
        # IO.inspect err
        # conn
        # |> redirect(to: "/login")
  end
end
