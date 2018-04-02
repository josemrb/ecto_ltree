defmodule EctoLtree.Functions do
  @moduledoc """
  This module exposes the `ltree` functions.
  For more information see the [PostgreSQL documentation](https://www.postgresql.org/docs/current/static/ltree.html#LTREE-FUNC-TABLE).
  """

  @doc """
  subpath of `ltree` from position start to position end-1 (counting from 0).
  """
  defmacro subltree(ltree, start, finish) do
    quote do: fragment("SUBLTREE(?, ?, ?)", unquote(ltree), unquote(start), unquote(finish))
  end

  @doc """
  subpath of `ltree` starting at position offset, extending to end of path.
  If offset is negative, subpath starts that far from the end of the path.
  """
  defmacro subpath(ltree, offset) do
    quote do: fragment("SUBPATH(?, ?)", unquote(ltree), unquote(offset))
  end

  @doc """
  subpath of `ltree` starting at position offset, length len.
  If offset is negative, subpath starts that far from the end of the path.
  If len is negative, leaves that many labels off the end of the path.
  """
  defmacro subpath(ltree, offset, len) do
    quote do: fragment("SUBPATH(?, ?, ?)", unquote(ltree), unquote(offset), unquote(len))
  end

  @doc """
  number of labels in path.
  """
  defmacro nlevel(ltree) do
    quote do: fragment("NLEVEL(?)", unquote(ltree))
  end

  @doc """
  position of first occurrence of b in a; -1 if not found.
  """
  defmacro index(a, b) do
    quote do: fragment("INDEX(?, ?)", unquote(a), unquote(b))
  end

  @doc """
  position of first occurrence of b in a, searching starting at offset; negative offset means start -offset labels from the end of the path.
  """
  defmacro index(a, b, offset) do
    quote do: fragment("INDEX(?, ?, ?)", unquote(a), unquote(b), unquote(offset))
  end

  @doc """
  cast `text` to `ltree`.
  """
  defmacro text2ltree(text) do
    quote do: fragment("TEXT2LTREE(?)", unquote(text))
  end

  @doc """
  cast `ltree` to `text`.
  """
  defmacro ltree2text(ltree) do
    quote do: fragment("LTREE2TEXT(?)", unquote(ltree))
  end

  @doc """
  lowest common ancestor.
  """
  defmacro lca(a, b) do
    quote do: fragment("LCA(?, ?)", unquote(a), unquote(b))
  end
end
