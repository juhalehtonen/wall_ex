defmodule WallExWeb.Router do
  use WallExWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :metrics do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", WallExWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/", Wobserver do
    pipe_through(:metrics)
    forward("/wobserver", Web.Router)
  end

  # Other scopes may use custom stacks.
  # scope "/api", WallExWeb do
  #   pipe_through :api
  # end
end
