defmodule WallExWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :wall_ex

  socket "/socket", WallExWeb.UserSocket,
  websocket: [
    timeout: 45_000,
    check_origin: [
      "//localhost",
      "//127.0.0.1",
      "https://wallex.herokuapp.com",
      "https://wallex-pr-1.herokuapp.com",
      "https://wallex-pr-2.herokuapp.com",
      "https://wallex-pr-3.herokuapp.com",
      "https://wallex-pr-4.herokuapp.com",
      "https://wallex-pr-5.herokuapp.com",
      "https://wallex-pr-6.herokuapp.com",
      "https://wallex-pr-7.herokuapp.com",
      "https://wallex-pr-8.herokuapp.com",
      "https://wallex-pr-9.herokuapp.com",
      "https://wallex-pr-10.herokuapp.com",
      "https://wallex-pr-11.herokuapp.com",
      "https://wallex-pr-12.herokuapp.com",
      "https://wallex-pr-13.herokuapp.com",
      "https://wallex-pr-14.herokuapp.com",
      "https://wallex-pr-16.herokuapp.com",
      "https://wallex-pr-17.herokuapp.com",
      "https://wallex-pr-18.herokuapp.com",
      "https://wallex-pr-19.herokuapp.com",
      "https://wallex-pr-20.herokuapp.com",
      "https://wallex-pr-21.herokuapp.com",
      "https://wallex-pr-22.herokuapp.com",
      "https://wallex-pr-23.herokuapp.com",
      "https://wallex-pr-24.herokuapp.com",
      "https://wallex-pr-25.herokuapp.com",
      "https://wallex-pr-26.herokuapp.com",
      "https://wallex-pr-27.herokuapp.com",
      "https://wallex-pr-28.herokuapp.com",
      "https://wallex-pr-29.herokuapp.com",
      "https://wallex-pr-30.herokuapp.com",
      "https://wallex-pr-31.herokuapp.com"
    ]
  ]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :wall_ex, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_wall_ex_key",
    signing_salt: "G2j1CDr3"

  plug WallExWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
