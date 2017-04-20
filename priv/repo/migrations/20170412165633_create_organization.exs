defmodule Newline.Repo.Migrations.CreateOrganization do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string, null: false

      timestamps()
    end
    create unique_index(:organizations, [:name])
  end
end
