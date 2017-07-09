# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :newline,
  ecto_repos: [Newline.Repo]

# Configures the endpoint
config :newline, Newline.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OBdEolnShHTCHgXNoGiRXrfefvVfGtce5YBg5JNscY3axGiLgXUIhyRuQ0HV3Tnf",
  render_errors: [view: Newline.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Newline.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :newline, Newline.Accounts.Social.Gumroad,
  client_id: System.get_env("GUMROAD_CLIENT_ID"),
  client_secret: System.get_env("GUMROAD_CLIENT_SECRET"),
  redirect_uri: System.get_env("GUMROAD_REDIRECT_URI")

config :newline, Newline.Accounts.Social.Github,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
  redirect_uri: System.get_env("GITHUB_REDIRECT_URI")

config :ueberauth, Ueberauth,
  providers: [
    github: { Ueberauth.Strategy.Github, [] }
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :bamboo, Newline.Email,
  adapter: Bamboo.SMTPAdapter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
