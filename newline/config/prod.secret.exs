use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :newline, Newline.Endpoint,
  secret_key_base: "5PXNRRKRBlrHqFCHH8Uof/gNqz8K43xYm6E4JXtfHpwcBn6iuRurrdsI3xzMdX1t"

# Configure your database
config :newline, Newline.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "C4FYD4k3WTAypfQ",
  database: "newline_prod",
  hostname: "localhost",
  port: 5432,
  pool_size: 20
