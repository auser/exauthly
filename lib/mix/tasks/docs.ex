defmodule Mix.Tasks.Docs do
  use Mix.Task

  @shortdoc "Generates documentation for the local site"

  def run(_args) do
    Mix.shell.cmd("graphdoc -e http://localhost:4000/graphql -o ./doc/schema")
  end
end