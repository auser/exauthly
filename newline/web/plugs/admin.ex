defmodule Newline.Plug.Admin do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    handle_check_admin(conn, conn.assigns[:current_user])
  end

  defp handle_check_admin(conn, %Newline.User{admin: true}) do
    conn |> assign(:admin, true)
  end
  defp handle_check_admin(conn, nil) do
    conn |> assign(:admin, false)
  end
end
