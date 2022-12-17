defmodule EctoLtree.Item do
  @moduledoc """
  Item schema module
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias EctoLtree.LabelTree, as: Ltree

  schema "items" do
    field(:path, Ltree)
    field(:paths, {:array, Ltree})
  end

  def changeset(item, params \\ %{}) do
    item
    |> cast(params, [:path])
  end
end
