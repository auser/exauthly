defmodule Newline.Plugs.BrowserContext do
  @moduledoc """
  Populating context with current_user, and later viewing_date
  """
  @behaviour Plug

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    assign(conn, :current_user, user)
  end
end
