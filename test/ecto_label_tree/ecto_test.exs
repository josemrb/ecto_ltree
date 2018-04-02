defmodule EctoLtree.EctoTest do
  use EctoLtree.EctoCase, async: true
  alias EctoLtree.Item

  describe "Ecto integration" do
    test "can insert record" do
      record = Item.changeset(%Item{}, %{path: "this.is.the.one"})
      assert {:ok, _schema} = Repo.insert(record)
    end

    test "can load record" do
      %Item{}
      |> Item.changeset(%{path: "this.is.the.one"})
      |> Repo.insert!()

      assert 0 < Repo.one(from(i in Item, select: count(i.id)))
    end

    test "can query record" do
      %Item{}
      |> Item.changeset(%{path: "this.is.the.one"})
      |> Repo.insert!()

      query = from(i in Item, select: count(i.id))
      assert 0 < Repo.one(query)
    end
  end
end
