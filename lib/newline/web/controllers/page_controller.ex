defmodule Newline.Web.PageController do
  use Newline.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
