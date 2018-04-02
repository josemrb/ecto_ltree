defmodule EctoLtree.TestRepo do
  use Ecto.Repo, otp_app: :ecto_ltree

  def config_postgrex() do
    config()
    |> Keyword.take([:hostname, :port, :database, :username, :password, :types])
  end
end
