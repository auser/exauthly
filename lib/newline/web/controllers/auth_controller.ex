defmodule Newline.Web.AuthController do
  @moduledoc """
  Auth controller
  """

  use Newline.Web, :controller
  alias Newline.Accounts.SocialAccount
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helper.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate")
    |> redirect(to: "/login")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider} = _params) do
    # case
    cs = SocialAccount.changeset_from_auth(%SocialAccount{}, provider, auth)
    IO.inspect cs
    conn
    |> redirect(to: "/login")
  end
end
