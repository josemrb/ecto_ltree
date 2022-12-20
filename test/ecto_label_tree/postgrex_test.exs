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
    [[_, result_path, _]] = result.rows

    assert path == result_path
    assert {:ok, _} = Postgrex.query(pid, "TRUNCATE TABLE items", [])
  end

  test "query item", context do
    pid = context[:pid]
    root = "this.is"
    path = root <> ".the.path"
    {:ok, _} = Postgrex.query(pid, "INSERT INTO items (path) VALUES ($1)", [path])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM items WHERE path <@ $1;", [root])
    [[_, result_path, _]] = result.rows

    assert path == result_path
    assert {:ok, _} = Postgrex.query(pid, "TRUNCATE TABLE items", [])
  end

  test "lquery array", context do
    pid = context[:pid]
    lqueries = ["*.path1.*", "*.path2.*"]

    # encode
    result = Postgrex.query!(pid, "SELECT $1::lquery[]", [lqueries])
    assert [[lqueries]] == result.rows

    # decode 
    result = Postgrex.query!(pid, "SELECT '{*.path1.*,*.path2.*}'::lquery[]", [])
    assert [[lqueries]] == result.rows
  end

  test "ltree array", context do
    pid = context[:pid]
    ltrees = ["this.is.path1", "this.is.path2"]

    # encode
    result = Postgrex.query!(pid, "SELECT $1::ltree[]", [ltrees])
    assert [[ltrees]] == result.rows

    # decode 
    result = Postgrex.query!(pid, "SELECT '{this.is.path1,this.is.path2}'::ltree[]", [])
    assert [[ltrees]] == result.rows
  end
end
