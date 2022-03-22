defmodule EctoLtree.TestApp do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {EctoLtree.TestRepo, []}
    ]

    Supervisor.start_link(children, name: __MODULE__, strategy: :one_for_one)
  end
end
