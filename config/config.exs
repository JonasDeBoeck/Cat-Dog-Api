# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :majorProject,
  ecto_repos: [MajorProject.Repo]

config :majorProject_web, MajorProjectWeb.Guardian,
  issuer: "majorProject_web",
  secret_key: "S7rRGa6+hp37NFmtg9eLMO9yfO1Sbl0GsEA5KWzTawJkhVbc25pURpite5ZLyloG"

config :majorProject_web,
  ecto_repos: [MajorProject.Repo],
  generators: [context_app: :majorProject]

# Configures the endpoint
config :majorProject_web, MajorProjectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ENrHpay8/A6fJwyb/ZQGeO1VNMlrrtPfbVghe1ztv056EMa5ygy5KANpwP/WQHzA",
  render_errors: [view: MajorProjectWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MajorProjectWeb.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "r/Ow6ssJ"]

config :majorProject, MajorProjectWeb.GetText,
  locales: ~w(en nl),
  default_locale: "en"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
