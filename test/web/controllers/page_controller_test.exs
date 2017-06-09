defmodule Newline.Web.PageControllerTest do
  use Newline.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "<div id=\"root\""
  end
end
