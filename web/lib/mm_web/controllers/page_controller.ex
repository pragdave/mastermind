defmodule MmWeb.PageController do
  use MmWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
