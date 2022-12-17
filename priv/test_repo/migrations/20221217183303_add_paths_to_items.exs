defmodule EctoLtree.TestRepo.Migrations.AddPathsToItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :paths, {:array, :ltree}
    end
  end
end
