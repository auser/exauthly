defmodule Newline.Mixfile do
  use Mix.Project

  def project do
    [app: :newline,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps(Mix.env)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Newline.Application, []},
     extra_applications: applications(Mix.env)]
  end

  defp applications(_) do
    [
      :logger,
      :runtime_tools,
      :comeonin,
      :ja_serializer,
      :timex,
      :corsica,
      :oauth2,
      :httpoison
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps(:test) do
    deps(:dev) ++ [{:ex_machina, "~> 2.0"}]
  end
  defp deps(:dev) do
    deps(:all) ++ [
      {:cortex, "~> 0.1"},
      {:remix, "~> 0.0", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      # {:mix_docker, github: "Recruitee/mix_docker"},
    ]
  end
  defp deps(_) do
    [{:bamboo, "~> 1.0.0-rc.1"},
     {:phoenix, "~> 1.3.0-rc", override: true},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.2"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: [:dev, :dev_stage]},
     {:gettext, "~> 0.11"},
     {:credo, "~> 0.5", only: [:dev, :test]},
     {:comeonin, "~> 3.0"},
     {:guardian, "~> 0.14"},
     {:cowboy, "~> 1.0"},
     {:ja_serializer, "~> 0.12.0"},
     {:timex, "~> 3.1"},
     {:timex_ecto, "~> 3.1"},
     {:absinthe, "~> 1.3.0-beta.2"},
     {:absinthe_plug, "~> 1.3.0-beta.0"},
     {:absinthe_ecto, git: "https://github.com/absinthe-graphql/absinthe_ecto.git"},
     {:canary, "~> 1.1"},
     {:corsica, "~> 1.0"},
     {:distillery, "~> 1.4"},
     {:oauth2, "~> 0.9.1"},
     {:httpoison, "~> 0.11.2"},
     {:ueberauth, "~> 0.4.0"},
     {:ueberauth_github, "~> 0.4.1"},
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
