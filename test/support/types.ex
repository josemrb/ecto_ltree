Postgrex.Types.define(
  EctoLtree.TestTypes,
  [EctoLtree.Postgrex.Lquery, EctoLtree.Postgrex.Ltree, EctoLtree.Postgrex.LqueryArray, EctoLtree.Postgrex.LtreeArray] ++ Ecto.Adapters.Postgres.extensions()
)
