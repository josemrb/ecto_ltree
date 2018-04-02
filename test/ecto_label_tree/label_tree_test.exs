defmodule EctoLtree.LabelTreeTest do
  use EctoLtree.EctoCase, async: true
  alias EctoLtree.LabelTree, as: Ltree

  describe "Ltree.cast/1" do
    test "top label" do
      {:ok, result} = Ltree.cast("top")
      assert %Ltree{} = result
      assert 1 = length(result.labels)
    end

    test "more than one label" do
      {:ok, result} = Ltree.cast("top.countries.south_america")
      assert %Ltree{} = result
      assert 3 = length(result.labels)
    end

    test "label chars" do
      assert {:ok, %Ltree{}} = Ltree.cast("411_valid_chars")
      assert :error == Ltree.cast("invalid chars")
    end

    test "label length" do
      long_label = String.duplicate("long", 64)
      assert {:ok, %Ltree{}} = Ltree.cast(long_label)

      # 260
      too_long_label = String.duplicate("too_long", 33)
      assert :error == Ltree.cast(too_long_label)
    end
  end
end
