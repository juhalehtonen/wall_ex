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

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Storage expiration time in nanoseconds. Nanoseconds are used because milliseconds
# used as keys could still be duplicates when drawing things fast, so they would
# be discared by ETS when trying to store them. For reference, ten seconds in
# nanoseconds would be 10_000_000_000.
config :wall_ex, storage_expiration_time: 6_000_000_000_000

# How long to wait in milliseconds until each periodic check of expiring drawings.
config :wall_ex, storage_expiration_check_period: 60_000

config :wall_ex, WallExWeb.Endpoint,
  live_view: [signing_salt: "dnRdjNUzr7gTaubh+d5WSZ5BwAawhiSi"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
