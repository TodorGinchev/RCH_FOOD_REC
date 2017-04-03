defmodule Imageapi.PageController do
  use Imageapi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
