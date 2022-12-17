# Copyright 2013 Eric Meadows-Jönsson
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

defmodule EctoLtree.Postgrex.Ltree do
  @moduledoc """
  This module provides the necessary functions to encode and decode PostgreSQL’s
  `ltree` data type to and from Elixir values.

  Implements the Postgrex.Extension behaviour.
  """

  @behaviour Postgrex.Extension

  # It can be memory efficient to copy the decoded binary because a
  # reference counted binary that points to a larger binary will be passed
  # to the decode/4 callback. Copying the binary can allow the larger
  # binary to be garbage collected sooner if the copy is going to be kept
  # for a longer period of time. See [`:binary.copy/1`](http://www.erlang.org/doc/man/binary.html#copy-1) for more
  # information.
  @impl true
  def init(opts) do
    Keyword.get(opts, :decode_copy, :copy)
  end

  # Use this extension when `send` from %Postgrex.TypeInfo{} is "ltree_send"
  @impl true
  def matching(_state), do: [send: "ltree_send"]

  @impl true
  def format(_state), do: :binary

  # Use quoted expression to encode a string that is the same as
  # postgresql's ltree text format. The quoted expression should contain
  # clauses that match those of a `case` or `fn`. Encoding matches on the
  # value and returns encoded `iodata()`. The first 4 bytes in the
  # `iodata()` must be the byte size of the rest of the encoded data, as a
  # signed 32bit big endian integer.
  @impl true
  def encode(_state) do
    quote do
      bin when is_binary(bin) ->
        # ltree binary formats are versioned
        # see: https://github.com/postgres/postgres/blob/master/contrib/ltree/ltree_io.c
        version = 1
        size = byte_size(bin) + 1
        [<<size::signed-size(32)>>, <<version::int8()>> | bin]
    end
  end

  # Use quoted expression to decode the data to a string. Decoding matches
  # on an encoded binary with the same signed 32bit big endian integer
  # length header.
  @impl true
  def decode(:reference) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        <<_version::binary-size(1), ltree::binary>> = bin
        ltree
    end
  end

  def decode(:copy) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        <<version::binary-size(1), ltree::binary>> = bin
        :binary.copy(ltree)
    end
  end
end
