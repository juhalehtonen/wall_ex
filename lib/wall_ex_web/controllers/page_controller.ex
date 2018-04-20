defmodule WallExWeb.PageController do
  use WallExWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
