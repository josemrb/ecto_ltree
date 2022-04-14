defmodule EctoLtree.LabelTree do
  @moduledoc """
  This module defines the LabelTree struct.
  Implements the Ecto.Type behaviour.

  ## Fields
    * `labels`
  """

  use Ecto.Type

  alias EctoLtree.LabelTree, as: Ltree

  @type label :: String.t()
  @type t :: %__MODULE__{
          labels: [label()]
        }

  defstruct labels: []

  @spec init([label()]) :: t()
  def init(labels) do
    %__MODULE__{labels: labels}
  end

  @labelpath_size_max 2048

  @doc """
  Provides custom casting rules from external data to internal representation.
  """
  @spec cast(String.t()) :: {:ok, t} | :error
  def cast(string) when is_binary(string) and byte_size(string) <= @labelpath_size_max do
    labels_result =
      string
      |> String.split(".")
      |> Enum.map(&cast_label/1)

    if Enum.any?(labels_result, fn i -> i == :error end) do
      :error
    else
      {:ok, init(Enum.map(labels_result, fn {:ok, v} -> v end))}
    end
  end

  def cast(%Ltree{} = struct) do
    {:ok, struct}
  end

  def cast(_), do: :error

  @label_size_max 256
  @label_regex ~r/[A-Za-z0-9_]{1,256}/

  @spec cast_label(label()) :: {:ok, String.t()} | :error
  defp cast_label(string) when is_binary(string) and byte_size(string) <= @label_size_max do
    string_length = String.length(string)

    case Regex.run(@label_regex, string, return: :index) do
      [{0, last}] when last == string_length ->
        {:ok, string}

      _ ->
        :error
    end
  end

  defp cast_label(_), do: :error

  @doc """
  From internal representation to database.
  """
  @spec dump(t) :: {:ok, String.t()} | :error
  def dump(%Ltree{} = label_tree) do
    {:ok, decode(label_tree)}
  end

  def dump(_), do: :error

  @spec decode(t) :: String.t()
  def decode(%Ltree{} = label_tree) do
    Enum.join(label_tree.labels, ".")
  end

  @doc """
  From database to internal representation.
  """
  @spec load(String.t()) :: {:ok, t} | :error
  def load(labelpath) when is_binary(labelpath) do
    {:ok, init(String.split(labelpath, "."))}
  end

  def load(_), do: :error

  @doc """
  Returns the underlying schema type.
  """
  @spec type() :: :ltree
  def type, do: :ltree
end

defimpl String.Chars, for: EctoLtree.LabelTree do
  def to_string(%EctoLtree.LabelTree{} = label_tree), do: EctoLtree.LabelTree.decode(label_tree)
end
