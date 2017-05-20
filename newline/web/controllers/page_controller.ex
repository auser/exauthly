defmodule Newline.PageController do
  @moduledoc false
  use Newline.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
