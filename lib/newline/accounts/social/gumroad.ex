defmodule Newline.Accounts.Social.Gumroad do
  use OAuth2.Strategy
  alias OAuth2.Strategy.AuthCode

  def config do
    [
      strategy: __MODULE__,
      site: "https://api.gumroad.com",
      authorize_url: "https://api.gumroad.com/oauth/authorize",
      token_url: "https://api.gumroad.com/oauth/token"
    ]
  end

  def client do
    Application.get_env(:newline, Newline.Accounts.Social.Gumroad)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(client(), Keyword.merge(params, client_secret: client().client_secret), headers)
  end

  ## Callbacks
  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end

  def get_products!(client) do
    OAuth2.Client.get(client, "/v2/products")
  end

end
