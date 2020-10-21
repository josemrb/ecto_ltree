defmodule EctoLtree.TestRepo do
  @moduledoc """
  Test Repo module
  """
  use Ecto.Repo,
    otp_app: :ecto_ltree,
    adapter: Ecto.Adapters.Postgres

  def config_postgrex do
    config()
    |> Keyword.take([:hostname, :port, :database, :username, :password, :types])
  end
end
