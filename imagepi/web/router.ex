defmodule Imageapi.Router do
  use Imageapi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
#    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/web", Imageapi do
    pipe_through :browser # Use the default browser stack

    #get "/", PageController, :index
#    resources "/test", TestController
  end

  # Other scopes may use custom stacks.
   scope "/", Imageapi do
     pipe_through :api
     resources "/test", TestController
   end
end
