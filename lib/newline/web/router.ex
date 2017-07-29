defmodule Newline.Web.Router do
  use Newline.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug JaSerializer.Deserializer
    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      json_decoder: Poison
    plug :accepts, ["json", "json-api"]
    plug Corsica, origins: "*", allow_headers: ["content-type", "authorization"]
  end

  pipeline :bearer_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  # GraphQL
  pipeline :gql_context do
    plug Newline.Plug.Context
  end

  scope "/graphql" do
    pipe_through [:api, :bearer_auth, :gql_context]

    forward "/", Absinthe.Plug, schema: Newline.Schema
  end

  if Mix.env != :prod do
    scope "/graphiql" do
      pipe_through [:api, :bearer_auth, :gql_context]
      forward "/", Absinthe.Plug.GraphiQL, schema: Newline.Schema
    end
  end

  scope "/api", Newline.Web do
    pipe_through :api

    post "/sessions", SessionController, :create
    delete "/sessions", SessionController, :delete
    post "/sessions/refresh", SessionController, :refresh
    resources "/users", UserController, only: [:create]
  end

  # AUTH
  scope "/auth", Newline.Web do
    pipe_through [:browser]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  scope "/", Newline.Web do
    pipe_through [:browser, :bearer_auth]

    # get "/login", SessionController, :index
    # post "/login", SessionController, :create
    # delete "/login", SessionController, :delete

    # # Social auth
    # get "/auth/proxy", AuthController, :proxy
    # get "/auth/:provider", AuthController, :index
    # get "/auth/:provider/callback", AuthController, :callback
    # delete "/logout", AuthController, :delete
    get "/*path", PageController, :index
  end
end
