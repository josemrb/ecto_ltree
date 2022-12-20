defmodule EctoLtree.Postgrex.LtreeArray do
  @moduledoc """
  This module provides the necessary functions to encode and decode an array of PostgreSQL’s
  `ltree` data type to and from Elixir values. Implements the Postgrex.Extension behaviour.
  """

  @behaviour Postgrex.Extension

  @impl true
  def init(opts) do
    Keyword.get(opts, :decode_copy, :copy)
  end

  @impl true
  def matching(_state), do: [type: "_ltree"]

  @impl true
  def format(_state), do: :text

  @impl true
  def encode(_state) do
    quote do
      ltrees when is_list(ltrees) ->
        iodata = ["{", Enum.intersperse(ltrees, ",") | "}"]
        size = IO.iodata_length(iodata)
        [<<size::signed-size(32)>> | iodata]
    end
  end

  @impl true
  def decode(:reference) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        bin |> String.trim_leading("{") |> String.trim("}") |> String.split(",")
    end
  end

  def decode(:copy) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        :binary.copy(bin) |> String.trim_leading("{") |> String.trim("}") |> String.split(",")
    end
  end
end
