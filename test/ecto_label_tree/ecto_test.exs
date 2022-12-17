defmodule EctoLtree.EctoTest do
  use EctoLtree.EctoCase, async: true
  alias EctoLtree.Item
  alias EctoLtree.TestContext

  describe "Ecto integration" do
    test "can insert record" do
      path = "this.is.the.one"
      paths = ["this.is.path1", "this.is.path2"]

      assert {:ok, _schema} = TestContext.create_item(path, paths)
    end

    test "can load record" do
      TestContext.create_item("this.is.the.one")

      assert 0 < Repo.one(from(i in Item, select: count(i.id)))
    end

  end
end
