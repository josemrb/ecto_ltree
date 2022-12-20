defmodule EctoLtree.TestContext do
  @moduledoc """
  Test Context module
  """

  alias EctoLtree.Item
  alias EctoLtree.TestRepo

  def create_item(path, paths \\ nil) do
    %Item{}
    |> Item.changeset(%{path: path, paths: paths})
    |> TestRepo.insert()
  end
end
