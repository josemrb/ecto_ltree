{:ok, _} = Application.ensure_all_started(:postgrex)
{:ok, _} = Application.ensure_all_started(:ecto)
EctoLtree.TestApp.start(:normal, [])

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(EctoLtree.TestRepo, :manual)
