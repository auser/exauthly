defmodule Mix.Tasks.Compose do
  @moduledoc false
  use Mix.Task

  @shortdoc "Run Docker Compose to start up an orchestrated multi-container runtime of this project. Options: up, down, release, build"

  def run(args) do
    case Mix.shell.cmd("docker-compose version", [quiet: true]) do
      0 ->
        compose(args)
      _err -> Mix.shell.error "docker-compose executable not found. Installation page: https://docs.docker.com/compose/install"
    end
  end

  def compose(["up"]) do
    Mix.shell.cmd("docker-compose up")
  end

  def compose(["down"]) do
    Mix.shell.cmd("docker-compose down")
  end

  def compose(["release", env]) do
    System.put_env("MIX_ENV", env)
    Mix.shell.cmd "mix compile"
    Mix.shell.cmd "mix release"
    Mix.shell.cmd "mix compose build"
  end

  def compose(["build"]) do
    version = Keyword.fetch!(Mix.Project.config, :version)
    Mix.shell.info "Version: #{version}"
    Mix.shell.cmd "VERSION=#{version} docker-compose build"
  end 

end