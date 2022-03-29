defmodule EctoLtree.FunctionsTest do
  use EctoLtree.EctoCase, async: true
  import EctoLtree.Functions
  alias EctoLtree.Item
  alias EctoLtree.Items

  describe "subltree/3" do
    test "returns value" do
      inserted = Items.add_item!("top.sciences.mathematics")

      query = from(item in Item, where: subltree(item.path, 0, 2) == "top.sciences")

      assert [inserted] == query |> Repo.all()
    end
  end

  describe "subpath/2" do
    test "returns value" do
      Items.add_item!("top.sciences.physics")

      query = from(item in Item, select: subpath(item.path, 1))

      assert ["sciences.physics"] == query |> Repo.all()
    end
  end

  describe "subpath/3" do
    test "returns value" do
      inserted = Items.add_item!("top.sciences.physics")

      query = from(item in Item, where: subpath(item.path, -1, 1) == "physics")

      assert [inserted] == query |> Repo.all()
    end
  end

  describe "nlevel/1" do
    test "returns value" do
      Items.add_item!("top.sciences.physics")

      query = from(item in Item, select: nlevel(item.path))

      assert [3] == query |> Repo.all()
    end
  end

  describe "index/2" do
    test "returns value" do
    end
  end

  describe "index/3" do
    test "returns value" do
    end
  end

  describe "text2ltree/1" do
    test "returns value" do
    end
  end

  describe "ltree2text/1" do
    test "returns value" do
    end
  end

  describe "lca/2" do
    test "returns value" do
      Items.add_item!("top.sciences.mathematics")

      query = from(item in Item, select: lca(item.path, "top.sciences.physics"))

      assert ["top.sciences"] == query |> Repo.all()
    end
  end
end
