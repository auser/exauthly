defmodule Newline.Router do
  use Newline.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      json_decoder: Poison
    plug :accepts, ["json"]
    plug Corsica, origins: "*", allow_headers: ["content-type", "authorization"]
  end

  pipeline :bearer_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated, 
      handler: Newline.GuardianErrorHandler
  end

  pipeline :current_user do
    plug Newline.Plug.CurrentUser
  end

  pipeline :check_admin do
    plug Newline.Plug.Admin
    plug Guardian.Plug.EnsurePermissions, 
      handler: Newline.GuardianErrorHandler, 
      default: [:read, :write]
  end

  pipeline :gql_context do
    plug Newline.Plug.Context
  end

  scope "/", Newline do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/graphql" do
    pipe_through [:api, :bearer_auth, :gql_context, :check_admin]

    forward "/", Absinthe.Plug, schema: Newline.Schema
  end

  # if Mix.env == :dev do
    scope "/graphiql" do
      pipe_through [:api, :bearer_auth, :gql_context]
      forward "/", Absinthe.Plug.GraphiQL, schema: Newline.Schema
    end
  # end

  scope "/api", Newline do
    pipe_through [:api, :bearer_auth, :current_user]

    # public v1 routes
    scope "/v1", V1, as: :v1 do
      post "/signup", UserController, :create
      post "/login", SessionController, :create
      post "/password/request", UserController, :request_password_reset, as: :reset
      post "/password/reset", UserController, :password_reset
    end
  end


  # Other scopes may use custom stacks.
  # scope "/api", Newline do
  #   pipe_through :api
  # end
end
