defmodule EctoLtree.Items do
  @moduledoc false

  alias EctoLtree.Item
  alias EctoLtree.TestRepo

  def add_item!(path) do
    %Item{}
    |> Item.changeset(%{path: path})
    |> TestRepo.insert!()
  end
end
