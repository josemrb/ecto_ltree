defmodule EctoLtree.EctoTest do
  use EctoLtree.EctoCase, async: true
  alias EctoLtree.Item
  alias EctoLtree.TestContext

  describe "Ecto integration" do
    test "can insert record" do
      path = "this.is.the.one"
      split_path = String.split(path, ".")
      paths = ["this.is.path1", "this.is.path2"]
      split_paths = Enum.map(paths, &String.split(&1, "."))

      assert {:ok, schema} = TestContext.create_item(path, paths)
      assert split_path  == schema.path.labels
      assert split_paths  == Enum.map(schema.paths, & &1.labels)
    end

    test "can load record" do
      TestContext.create_item("this.is.the.one")
      assert 0 < Repo.one(from(i in Item, select: count(i.id)))
    end
  end
end
