defmodule EctoLtree.TestRepo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :path, :ltree
    end

    create index(:items, [:path], using: :gist)
  end
end
