defmodule Mix.Tasks.Webpacker.Frontend do
  use Mix.Task

  @shortdoc "Installs npm modules via yarn or npm."

  def run(_) do
    System.cmd(package_manager(), ["install"], [
      cd: "assets",
      into: IO.stream(:stdio, :line),
      stderr_to_stdout: true,
      parallelism: true
    ])
  end

  defp package_manager do
    if has_yarn?(), do: "yarn", else: "npm"
  end

  defp has_yarn? do
    {_binary, exit_code} = System.cmd("which", ["yarn"])
    if exit_code == 0, do: true, else: false
  end
end
