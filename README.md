# EctoLtree
[![Hex Version](https://img.shields.io/hexpm/v/ecto_ltree.svg?style=flat)](https://hex.pm/packages/ecto_ltree)

A library that provides the necessary modules to support the PostgreSQL’s
`ltree` data type with Ecto.

## Quickstart

### 1. Add the package to your list of dependencies in `mix.exs`

#### If you are using Elixir >= v1.7 and Ecto ~> 3.2

```elixir
def deps do
  [
    ...
    {:ecto_ltree, "~> 0.3.0"}
  ]
end
```

#### If you are using Ecto ~> 3.0

```elixir
def deps do
  [
    ...
    {:ecto_ltree, "~> 0.2.0"}
  ]
end
```

#### If you are using Elixir v1.6 and Ecto ~> 2.1

```elixir
def deps do
  [
    ...
    {:ecto_ltree, "~> 0.1.0"}
  ]
end

```
### 2. Define a type module with our custom extensions

```elixir
Postgrex.Types.define(
  MyApp.PostgresTypes,
  [EctoLtree.Postgrex.Lquery, EctoLtree.Postgrex.Ltree] ++ Ecto.Adapters.Postgres.extensions()
)
```

### 3. Configure the Repo to use the previously defined type module

```elixir
  config :my_app, MyApp.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "postgres",
    password: "postgres",
    database: "my_app_dev",
    hostname: "localhost",
    poolsize: 10,
    pool: Ecto.Adapters.SQL.Sandbox,
    types: MyApp.PostgresTypes
```

### 4. Add a migration to enable the `ltree` extension

```elixir
defmodule MyApp.Repo.Migrations.CreateExtensionLtree do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION ltree",
            "DROP EXTENSION ltree")
  end
end
```

### 5. Add a migration to create your table

```elixir
defmodule MyApp.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :path, :ltree
    end

    create index(:items, [:path], using: :gist)
  end
end
```

### 6. Define an Ecto Schema

```elixir
defmodule MyApp.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias EctoLtree.LabelTree, as: Ltree

  schema "items" do
    field :path, Ltree
  end

  def changeset(item, params \\ %{}) do
    item
    |> cast(params, [:path])
  end
end
```

### 7. Usage

```elixir
iex(1)> alias MyApp.Repo
MyApp.Repo
iex(2)> alias MyApp.Item
MyApp.Item
iex(3)> import Ecto.Query
Ecto.Query
iex(4)> import EctoLtree.Functions
EctoLtree.Functions
iex(5)> Item.changeset(%Item{}, %{path: “1.2.3”}) |> Repo.insert!
%MyApp.Item{
  __meta__: #Ecto.Schema.Metadata<:loaded, “items”>,
  id: 1,
  path: %EctoLtree.LabelTree{labels: [“1”, “2”, “3”]}
}
iex(6)> from(item in Item, select: nlevel(item.path)) |> Repo.one
3
```

The documentation can be found at [hexdocs](https://hexdocs.pm/ecto_ltree).

## Copyright and License

Copyright (c) 2018-2019 Jose Miguel Rivero Bruno

The source code is licensed under [The MIT License (MIT)](LICENSE.md)
