defmodule EctoLtree.EctoTest do
  use EctoLtree.EctoCase, async: true
  alias EctoLtree.Item
  alias EctoLtree.TestContext

  describe "Ecto integration" do
    test "can insert record" do
      path = "this.is.the.one"
      {:ok, path_struct} = EctoLtree.LabelTree.cast(path)
      paths = ["this.is.path1", "this.is.path2"]

      path_structs =
        Enum.map(paths, fn path ->
          {:ok, path_struct} = EctoLtree.LabelTree.cast(path)
          path_struct
        end)

      assert {:ok, schema} = TestContext.create_item(path, paths)
      assert path_struct == schema.path
      assert path_structs == schema.paths
    end

    test "can load record" do
      TestContext.create_item("this.is.the.one")
      assert 0 < Repo.one(from(i in Item, select: count(i.id)))
    end
  end
end
