defmodule EctoLtree.Postgrex.LqueryArray do
  @moduledoc """
  This module provides the necessary functions to encode and decode an array of PostgreSQL’s
  `lquery` data type to and from Elixir values. Implements the Postgrex.Extension behaviour.
  """

  @behaviour Postgrex.Extension

  @impl true
  def init(opts) do
    Keyword.get(opts, :decode_copy, :copy)
  end

  @impl true
  def matching(_state), do: [type: "_lquery"]

  @impl true
  def format(_state), do: :text

  @impl true
  def encode(_state) do
    quote do
      lqueries when is_list(lqueries) ->
        iodata = ["{", Enum.intersperse(lqueries, ",") | "}"]
        size = IO.iodata_length(iodata)
        [<<size::signed-size(32)>> | iodata]
    end
  end

  @impl true
  def decode(:reference) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        <<"{", rest::binary>> = bin
        unquote(__MODULE__).decode(rest, [])
    end
  end

  def decode(:copy) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        <<"{", rest::binary>> = :binary.copy(bin)
        unquote(__MODULE__).decode(rest, <<>>, [])
    end
  end

  def decode("}", current_elem, acc), do: Enum.reverse([current_elem | acc])

  def decode(<<",", rest::binary>>, current_elem, acc),
    do: decode(rest, <<>>, [current_elem | acc])

  def decode(<<bin, rest::binary>>, current_elem, acc),
    do: decode(rest, <<current_elem::binary, bin>>, acc)
end
