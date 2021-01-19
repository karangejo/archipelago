# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :arch,
  ecto_repos: [Arch.Repo]

# Configures the endpoint
config :arch, ArchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Yi4nEmO2ade/Gq/AwTvws+81DNdjeOG4aIT6JrLpUB5+tBwevZXJelolqhpujmfA",
  render_errors: [view: ArchWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Arch.PubSub,
  live_view: [signing_salt: "nWDwS4XD"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
