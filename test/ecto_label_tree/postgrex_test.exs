defmodule EctoLtree.PostgrexTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = Postgrex.start_link(EctoLtree.TestRepo.config_postgrex())
    {:ok, [pid: pid]}
  end

  test "insert item", context do
    pid = context[:pid]
    path = "this.is.the.path"
    paths = ["this.is.path1", "this.is.path2"]

    {:ok, _} =
      Postgrex.query(pid, "INSERT INTO items (path, paths) VALUES ($1, $2)", [path, paths])

    {:ok, result} = Postgrex.query(pid, "SELECT * FROM items", [])
    [[_, result_path, result_paths]] = result.rows

    assert path == result_path
    assert paths == result_paths
    assert {:ok, _} = Postgrex.query(pid, "TRUNCATE TABLE items", [])
  end

  test "query item", context do
    pid = context[:pid]
    root = "this.is"
    path = root <> ".the.path"
    paths = ["this.is.path1", "this.is.path2"]

    {:ok, _} =
      Postgrex.query(pid, "INSERT INTO items (path, paths) VALUES ($1, $2)", [path, paths])

    {:ok, result} = Postgrex.query(pid, "SELECT * FROM items WHERE path <@ $1;", [root])
    [[_, result_path, result_paths]] = result.rows

    assert path == result_path
    assert paths == result_paths
    assert {:ok, _} = Postgrex.query(pid, "TRUNCATE TABLE items", [])
  end

  test "query array of lquery", context do
    pid = context[:pid]
    paths = ["this.is.path1", "this.is.path2"]
    lquery = ["*.path1.*", "*.path3.*"]

    {:ok, _} = Postgrex.query(pid, "INSERT INTO items (paths) VALUES ($1)", [paths])

    {:ok, result} =
      Postgrex.query(pid, "SELECT * FROM items WHERE paths ? $1::lquery[];", [lquery])

    [[_, _, result_paths]] = result.rows

    assert result_paths == paths
    assert {:ok, _} = Postgrex.query(pid, "TRUNCATE TABLE items", [])
  end
end
