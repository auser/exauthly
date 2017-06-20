defmodule Newline.Web.AuthController do
  use Newline.Web, :controller

  alias Newline.Accounts
  alias Newline.Accounts.Social.{Gumroad, Github}

  # def index(conn, %{"provider" => provider}) do
  #   redirect conn, external: authorize_url!(provider)
  # end

  # def delete(conn, _params) do
  #   conn
  #   |> configure_session(drop: true)
  #   |> redirect(to: "/")
  # end

  def proxy(conn, params) do
    %{
      "code" => code,
      "state" => state
    } = params
    decoded = state |> Poison.decode!
    %{
      "redirect_uri" => redirect_uri,
      "callback" => callback,
      "network" => provider,
      "display" => display,
      "scope" => scope,
      "state" => state
    } = decoded

    # %{"user_id" => user_id} = state

    client = get_token!(provider, code)

    {:ok, %OAuth2.Response{body: body}} = get_user!(provider, client)
    social_account_id = case provider do
      "github" ->
        %{"id" => user_id} = body
        Integer.to_string(user_id)
      "gumroad" ->
        %{"user_id" => user_id} = state
        user_id
    end
    params = Map.put(%{}, "user", body["user"])

    params = params
      |> Map.put("email", body["email"])
      |> Map.put("social_account_id", social_account_id)
      |> Map.put("social_account_name", provider)
      |> Map.put("auth_token", client.token.access_token)
      |> Map.put("refresh_token", client.token.refresh_token)

    # user_id = String.to_integer(state["user_id"])
    user_id = nil


    message = case Accounts.user_link_and_signup(provider, user_id, params) do
      {:error, reason} ->
        reason
      {:ok, _user} ->
        "success"
    end

    state = Poison.encode!(%{
      access_token: client.token.access_token,
      refresh_token: client.token.refresh_token,
      expires_at: client.token.expires_at,
      token_type: client.token.token_type,
      redirect_uri: redirect_uri,
      callback: callback,
      network: provider,
      display: display,
      scope: scope,
      social_account_id: social_account_id,
      # state: Poison.encode!(%{
        message: message
      # })
    })
    query = URI.encode(state)

    conn
    |> redirect(external: redirect_uri <> "#/state=" <> query)
  end

  # def callback(conn, %{"provider" => provider, "code" => code}) do
  #   client = get_token!(provider, code)
  #   {:ok, %OAuth2.Response{body: body}} = get_user!(provider, client)
  #   # Accounts.user_link_and_signup(provider, )
  #   IO.inspect body

  #   config = Application.get_env(
  #     :newline, Newline.Web.Endpoint
  #   )
  #   user_id = get_session(conn, :user_id)
  #   params = body["user"]
  #     |> Map.put("social_account_id", body["user"]["user_id"])

  #   IO.inspect user_id
  #   IO.inspect params
  #   case Accounts.user_link_and_signup(provider, user_id, params) do
  #     {:error, _} ->
  #       redirect(conn, external: config[:client_endpoint])
  #     {:ok, user} ->
  #       {:ok, jwt, claims} = Accounts.sign_in_user(:token, user)
  #       url = "#{config[:client_endpoint]}?#{URI.encode_query(%{"token" => jwt})}"
  #       IO.inspect url
  #       conn
  #       |> redirect(external: url)
  #   end
  #   # conn
  #   # # |> put_session(:current_user, user)
  #   # # |> put_session(:access_token, client.token.access_token)
  #   # |> redirect(external: config[:client_endpoint])
  # end

  # defp authorize_url!("gumroad"), do: Gumroad.authorize_url!
  # defp authorize_url(_), do: raise "No matching provider available"

  defp get_token!("gumroad", code), do: Gumroad.get_token!(code: code)
  defp get_token!("github", code), do: Github.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider"

  defp get_user!("gumroad", client) do
    OAuth2.Client.get(client, "/v2/user")
  end
  defp get_user!("github", client), do: OAuth2.Client.get(client, "/user")

end
