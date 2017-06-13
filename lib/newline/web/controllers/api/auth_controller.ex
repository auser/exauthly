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
    IO.inspect(client)
    {:ok, %OAuth2.Response{body: body}} = get_user!(provider, client)
    # Accounts.assciate_social_account(provider, )
    IO.inspect body

    config = Application.get_env(
      :newline, Newline.Web.Endpoint
    )
    conn
    # |> put_session(:current_user, user)
    # |> put_session(:access_token, client.token.access_token)
    |> redirect(external: config[:client_endpoint])
  end

  defp authorize_url!("gumroad"), do: Gumroad.authorize_url!
  defp authorize_url(_), do: raise "No matching provider available"

  defp get_token!("gumroad", code), do: Gumroad.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider"

  defp get_user!("gumroad", client) do
    OAuth2.Client.get(client, "/v2/user")
  end

end
