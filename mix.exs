defmodule EctoLtree.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_ltree,
      version: "0.2.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [flags: [:unmatched_returns, :error_handling, :race_conditions, :underspecs]],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      description: description(),
      package: package(),
      aliases: aliases(),
      deps: deps(),
      name: "EctoLtree",
      source_url: "https://github.com/josemrb/ecto_ltree",
      docs: [main: "readme", extras: ["README.md"]]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def elixirc_paths(:test), do: ["lib", "test/support"]
  def elixirc_paths(_), do: ["lib"]

  defp description() do
    "A library that provides the necessary modules to support the PostgreSQL’s `ltree` data type with Ecto."
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:ecto_sql, "~> 3.1", only: :test},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      maintainers: ["Jose Miguel Rivero Bruno (@josemrb)"],
      links: %{"GitHub" => "https://github.com/josemrb/ecto_ltree"},
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"]
    ]
  end
end
