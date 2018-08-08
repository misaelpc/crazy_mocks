# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :meapi_mocks,
  ecto_repos: [MeapiMocks.Repo]

# Configures the endpoint
config :meapi_mocks, MeapiMocksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Hy4VCCM2KtSiPoe3/k1IevsNGkjW2xOBolQM6TnhU9p29QteAYEP/vo+4OoBb3Kf",
  render_errors: [view: MeapiMocksWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MeapiMocks.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
