# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :imageapi,
  ecto_repos: [Imageapi.Repo]

# Configures the endpoint
config :imageapi, Imageapi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YL/cKJFYXK4qaBEKeZj+PC4z42JG3Ae5UgXrd5X6vR0M2THTtvFjMR44+6Llp2Bv",
  render_errors: [view: Imageapi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Imageapi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
