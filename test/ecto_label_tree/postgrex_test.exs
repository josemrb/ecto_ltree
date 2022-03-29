defmodule EctoLtree.PostgrexTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = Postgrex.start_link(EctoLtree.TestRepo.config_postgrex())
    {:ok, [pid: pid]}
  end

  test "insert item", context do
    pid = context[:pid]
    path = "this.is.the.path"
    {:ok, _} = Postgrex.query(pid, "INSERT INTO items (path) VALUES ($1)", [path])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM items", [])
    [[_, result_path]] = result.rows

    assert path == result_path
    assert {:ok, _} = Postgrex.query(pid, "TRUNCATE TABLE items", [])
  end

  test "query item", context do
    pid = context[:pid]
    root = "this.is"
    path = root <> ".the.path"
    {:ok, _} = Postgrex.query(pid, "INSERT INTO items (path) VALUES ($1)", [path])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM items WHERE path <@ $1;", [root])
    [[_, result_path]] = result.rows

    assert path == result_path
    assert {:ok, _} = Postgrex.query(pid, "TRUNCATE TABLE items", [])
  end
end
