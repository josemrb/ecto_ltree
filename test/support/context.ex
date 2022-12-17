defmodule EctoLtree.TestContext do
  @moduledoc """
  Test Context module
  """

  alias EctoLtree.Item
  alias EctoLtree.TestRepo

  def create_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> TestRepo.insert()
  end
end
