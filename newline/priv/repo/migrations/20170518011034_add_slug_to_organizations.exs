defmodule Newline.Repo.Migrations.AddSlugToOrganizations do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :slug, :string
    end

    create index(:organizations, ["lower(slug)"], name: :organizations_lower_slug_index, unique: true)
  end
end
