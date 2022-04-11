defmodule EctoLtree.TestContext do
  @moduledoc """
  Test Context module
  """

  alias EctoLtree.Item
  alias EctoLtree.TestRepo

  def create_item(path) do
    %Item{}
    |> Item.changeset(%{path: path})
    |> TestRepo.insert()
  end
end
