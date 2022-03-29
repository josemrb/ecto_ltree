defmodule EctoLtree.EctoTest do
  use EctoLtree.EctoCase, async: true
  alias EctoLtree.Item
  alias EctoLtree.Items

  describe "Ecto integration" do
    test "can insert record" do
      record = Item.changeset(%Item{}, %{path: "this.is.the.one"})
      assert {:ok, _schema} = Repo.insert(record)
    end

    test "can load record" do
      Items.add_item!("this.is.the.one")

      assert 0 < Repo.one(from(i in Item, select: count(i.id)))
    end
  end
end
