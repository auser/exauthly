defmodule Newline.Web.AuthController do
  use Newline.Web, :controller

  alias Newline.Accounts.Social.{Gumroad}

  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    IO.inspect provider
    client = get_token!(provider, code)

    user = get_user!(provider, client)

    IO.inspect user
    conn
    # |> put_session(:current_user, user)
    # |> put_session(:access_token, client.token.access_token)
    |> redirect(to: "/")
  end

  defp authorize_url!("gumroad"), do: Gumroad.authorize_url!
  defp authorize_url(_), do: raise "No matching provider available"

  defp get_token!("gumroad", code), do: Gumroad.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider"

  defp get_user!("gumroad", client) do
    OAuth2.Client.get!(client, "/v2/user")
  end

end
