use Mix.Config

if Mix.env() == :test do
  config :ecto_ltree, ecto_repos: [EctoLtree.TestRepo]

  config :ecto_ltree, EctoLtree.TestRepo,
    adapter: Ecto.Adapters.Postgres,
    username: "postgres",
    password: "postgres",
    database: "ecto_ltree_test",
    hostname: "localhost",
    poolsize: 10,
    pool: Ecto.Adapters.SQL.Sandbox,
    types: EctoLtree.TestTypes

  config :logger, level: :warn
end
