defmodule EctoLtree.TestApp do
  @moduledoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(EctoLtree.TestRepo, [])
    ]

    Supervisor.start_link(children, name: __MODULE__, strategy: :one_for_one)
  end
end
