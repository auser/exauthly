defmodule Newline.PageControllerTest do
  use Newline.ConnCase

  test "GET / includes a div#app", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "<div id=\"app\"></div>"
  end
end
