defmodule Newline.Repo.Migrations.AddOrganizationsAndMemberships do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string, null: false
      add :slug, :string, null: false

      timestamps()
    end

    create index :organizations, [:name], unique: true
    create index :organizations, [:slug], unique: true

    create table(:organization_memberships) do
      add :role, :string, null: false
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      add :member_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index :organization_memberships, [:member_id, :organization_id], unique: true, name: :organization_membership_unique_constraint_on_membership
  end
end
