defmodule EctoLtree.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_ltree,
      version: "0.1.1",
      elixir: "~> 1.6",
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
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.1"},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:excoveralls, "~> 0.8", only: :test}
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
