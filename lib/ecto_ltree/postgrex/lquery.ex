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
  def matching(_state), do: [type: "lquery"]

  @impl true
  def format(_state), do: :text

  @impl true
  def encode(_state) do
    quote do
      bin when is_binary(bin) ->
        [<<byte_size(bin)::signed-size(32)>> | bin]
    end
  end

  @impl true
  def decode(:reference) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        bin
    end
  end

  def decode(:copy) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        :binary.copy(bin)
    end
  end
end
