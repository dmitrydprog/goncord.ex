defmodule Goncord.PageController do
  use Goncord.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
