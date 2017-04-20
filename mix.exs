defmodule Newline.Mixfile do
  use Mix.Project

  def project do
    [app: :newline,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps(Mix.env)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Newline, []},
     applications: applications(Mix.env)]
  end

  defp applications(:dev) do
    applications(:all) ++ [:remix]
  end
  defp applications(_) do
    [
      :phoenix, 
      :phoenix_pubsub, 
      :phoenix_html, 
      :cowboy, 
      :logger, 
      :gettext,
      :phoenix_ecto,
      :postgrex,
      :absinthe,
      :absinthe_plug,
      :absinthe_ecto,
      :ja_serializer,
      :comeonin,
      :bamboo,
      :ueberauth,
      :guardian,
      :guardian_db,
      :corsica,
      :timex,
      :timex_ecto
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps(:test) do
    deps(:dev) ++ [
      {:ex_machina, "~> 2.0"}
    ]
  end
  defp deps(:dev) do
    deps(:all) ++ [
      {:remix, "~> 0.0"},
      {:mix_test_watch, "~> 0.3", only: :dev, runtime: false}
    ]
  end
  defp deps(_) do
    [
      {:phoenix, "~> 1.2.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:corsica, "~> 0.5.0"},
      {:absinthe, "~> 1.3.0-beta.2"},
      {:absinthe_plug, "~> 1.3.0-beta.0"},
      {:absinthe_ecto, git: "https://github.com/absinthe-graphql/absinthe_ecto.git"},
      {:guardian, "~> 0.14.2"},
      {:guardian_db, "~> 0.8.0"},
      {:ueberauth, "~> 0.4.0"},
      {:timex, "~> 3.1"},
      {:timex_ecto, "~> 3.1"},
      {:ecto, "~> 2.1"},
      {:postgrex, "~> 0.13"},
      {:comeonin, "~> 3.0"},
      {:bamboo, "~> 0.8.0"},
      {:poison, "~> 2.0"},
      {:ja_serializer, "~> 0.12.0"},
      {:distillery, "~> 1.3"},
      {:mix_docker, "~> 0.4.2"},
      {:segment, "~> 0.1"},
      {:canary, "~> 1.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
