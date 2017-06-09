defmodule Newline.Web.Router do
  use Newline.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  # GraphQL
  pipeline :gql_context do
    plug Newline.Plug.Context
  end

  scope "/graphql" do
    pipe_through [:api, :gql_context]

    forward "/", Absinthe.Plug, schema: Newline.Schema
  end

  # if Mix.env == :dev do
    scope "/graphiql" do
      pipe_through [:api, :gql_context]
      forward "/", Absinthe.Plug.GraphiQL, schema: Newline.Schema
    end
  # end

  scope "/api", Newline.Web do
    pipe_through :api

    post "/sessions", SessionController, :create
    delete "/sessions", SessionController, :delete
    post "/sessions/refresh", SessionController, :refresh
    resources "/users", UserController, only: [:create]
  end

  scope "/", Newline.Web do
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
  end
end
