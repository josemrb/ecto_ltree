defmodule EctoLtree.TestRepo.Migrations.CreateExtensionLtree do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION ltree",
            "DROP EXTENSION ltree")
  end
end
