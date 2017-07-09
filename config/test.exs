use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :newline, Newline.Web.Endpoint,
  http: [port: 4001],
  server: false,
  client_endpoint: "http://localhost:8080"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :newline, Newline.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "newline_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Newline",
  ttl: {30, :days},
  verify_issuer: true,
  secret_key: "Secret thing",
  serializer: Newline.GuardianSerializer

config :newline, Newline.Email,
  adapter: Bamboo.TestAdapter,
  from: "postmaster@newline.co"

