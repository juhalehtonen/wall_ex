defmodule WallExWeb.PageControllerTest do
  use WallExWeb.ConnCase

  test "GET / should contain a <canvas> element", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "<canvas"
  end
end
