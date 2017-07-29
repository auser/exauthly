defmodule Newline.Web.PageController do
  use Newline.Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.html", token: Guardian.Plug.current_token(conn))
  end
end
