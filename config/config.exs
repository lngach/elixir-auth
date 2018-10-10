# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :authenticate,
  ecto_repos: [Authenticate.Repo]

# Configures the endpoint
config :authenticate, AuthenticateWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wNoDZB4/bZnsPRJmAOQnJrG7IAKo+duvKujlIC8d/Xu3k7J5mCHMhPoAClXeuHoG",
  render_errors: [view: AuthenticateWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Authenticate.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :authenticate, Authenticate.Guardian,
        issuer: "authenticate",
        secret_key: "kP9jILDVxzK9vuyFtR8FxKWwlX12v+OMZerdZOHUbejII2+5rbEYa8W3eJxnIHbq"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
