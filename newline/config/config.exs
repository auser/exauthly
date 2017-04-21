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
config :newline, Newline.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tfw45t1CsAHayWHb2MzTzNeQ0tB45U9U/8UijxcyEhPRfsnB37vZvukvRQ/LH3pX",
  render_errors: [view: Newline.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Newline.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Micro.#{Mix.env}",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: to_string(Mix.env) <> "883z8H+L7TzqHAWozJ3lIORLjViEHH+ZfbOtll8Y7+afbASpdfZzp7gkgUzAKqAP",
  serializer: Newline.GuardianSerializer,
  permissions: %{default: [:read, :write]},
  hooks: GuardianDb

config :guardian_db, GuardianDb, 
        repo: Newline.Repo,
        schema_name: "auth_tokens",
        sweep_interval: 120 # 120 minutes

config :ueberauth, Ueberauth,
  base_path: "/api/v1/auth",
  providers: [
    google: { Ueberauth.Strategy.Github, [] },
    identity: { Ueberauth.Strategy.Identity, [
        callback_methods: ["POST"],
        uid_field: :username,
        nickname_field: :username,
    ]},
  ]

config :ueberauth, Ueberauth.Strategy.Github,
      client_id: System.get_env("GITHUB_CLIENT_ID") || "GITHUB_CLIENT_ID",
      client_secret: System.get_env("GITHUB_CLIENT_SECRET") || "GITHUB_CLIENT_SECRET",
      redirect_uri: System.get_env("GITHUB_REDIRECT_URI") || "http://localhost:4000/api/v1/auth/github/callback"
  
# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mix_docker, image: "auser/newline"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
