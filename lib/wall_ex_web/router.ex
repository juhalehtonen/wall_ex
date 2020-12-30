defmodule WallExWeb.Router do
  use WallExWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WallExWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    live_dashboard "/dashboard",
                   allow_destructive_actions: true,
                   metrics: WallExWeb.Telemetry
  end

  # Other scopes may use custom stacks.
  # scope "/api", WallExWeb do
  #   pipe_through :api
  # end
end
