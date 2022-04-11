defmodule EctoLtree.EctoTest do
  use EctoLtree.EctoCase, async: true
  alias EctoLtree.Item
  alias EctoLtree.TestContext

  describe "Ecto integration" do
    test "can insert record" do
      assert {:ok, _schema} = TestContext.create_item("this.is.the.one")
    end

    test "can load record" do
      TestContext.create_item("this.is.the.one")

      assert 0 < Repo.one(from(i in Item, select: count(i.id)))
    end
  end
end
