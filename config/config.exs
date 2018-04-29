# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :wall_ex, WallExWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "h1mGOQAgBr07j2+rSP0P4WQEhFWPn+3XbWEkaMgBTbTbSLL1ln8fvjyiTaDszWtY",
  render_errors: [view: WallExWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WallEx.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure wobserver
# - Use Phoenix' cowboy instead of starting its own
# - Do not attempt node discovery as we only run one node
config :wobserver,
  mode: :plug,
  remote_url_prefix: "/wobserver",
  discovery: :none

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
