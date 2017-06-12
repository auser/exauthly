defmodule Newline.Repo.Migrations.AddCurrentOrganizationIdToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :current_organization_id, references(:organizations, on_delete: :nothing)
    end
  end
end
