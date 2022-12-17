defmodule EctoLtree.Postgrex.Lquery do
  @moduledoc """
  This module provides the necessary functions to encode and decode PostgreSQL’s `lquery` data type to and from Elixir values.
  Implements the Postgrex.Extension behaviour.
  """

  @behaviour Postgrex.Extension

  @impl true
  def init(opts) do
    Keyword.get(opts, :decode_copy, :copy)
  end

  @impl true
  def matching(_state), do: [send: "lquery_send"]

  @impl true
  def format(_state), do: :binary

  @impl true
  def encode(_state) do
    quote do
      bin when is_binary(bin) ->
        # lquery binary formats are versioned
        # see: https://github.com/postgres/postgres/blob/master/contrib/ltree/ltree_io.c
        version = 1
        size = byte_size(bin) + 1
        [<<size::signed-size(32), version::int8()>> | bin]
    end
  end

  @impl true
  def decode(:reference) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        <<_version::binary-size(1), lquery::binary>> = bin
        lquery
    end
  end

  def decode(:copy) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        <<_version::binary-size(1), lquery::binary>> = bin
        :binary.copy(lquery)
    end
  end
end
