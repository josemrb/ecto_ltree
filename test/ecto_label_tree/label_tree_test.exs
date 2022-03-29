defmodule EctoLtree.LabelTreeTest do
  use EctoLtree.EctoCase, async: true

  alias EctoLtree.LabelTree

  describe "cast/1" do
    test "top label" do
      assert {:ok, result} = LabelTree.cast("top")
      assert %LabelTree{labels: ["top"]} == result
    end

    test "more than one label" do
      assert {:ok, result} = LabelTree.cast("top.countries.south_america")
      assert %LabelTree{labels: ["top", "countries", "south_america"]} == result
    end

    test "label with a space in it" do
      assert :error == LabelTree.cast("invalid chars")
    end

    test "label with a wild card in it" do
      assert :error == LabelTree.cast("top.*.bottom")
    end

    test "label with ❤️" do
      assert :error == LabelTree.cast("❤️")
    end

    test "label chars" do
      assert {:ok, result} = LabelTree.cast("411_valid_chars")
      assert %LabelTree{labels: ["411_valid_chars"]} == result
    end

    test "label length right at the max" do
      long_label = String.duplicate("a", 256)
      assert {:ok, %LabelTree{}} = LabelTree.cast(long_label)
    end

    test "label length is too long" do
      too_long_label = String.duplicate("a", 257)
      assert :error == LabelTree.cast(too_long_label)
    end

    test "returns the struct passed" do
      ltree = %LabelTree{labels: ["level1", "level2"]}

      assert {:ok, result} = LabelTree.cast(ltree)
      assert result == ltree
    end
  end

  describe "dump/1" do
    test "dumps the label tree" do
      ltree = %LabelTree{labels: ["level1", "level2"]}
      assert {:ok, "level1.level2"} == LabelTree.dump(ltree)
    end
  end

  describe "load/1" do
    test "loads the path from postgres" do
      assert {:ok, %LabelTree{labels: ["level1", "level2"]}} == LabelTree.load("level1.level2")
    end
  end

  describe "type/0" do
    test "returns :ltree" do
      assert LabelTree.type() == :ltree
    end
  end
end
