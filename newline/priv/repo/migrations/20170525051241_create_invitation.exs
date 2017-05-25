defmodule Newline.Repo.Migrations.CreateInvitation do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :user_id, references(:users)
      add :organization_id, references(:organizations)
      add :invitee_id, references(:users)
      add :token, :string
      add :accepted, :boolean, default: false 
      timestamps()
    end

    create index(:invitations, ["token"], unique: true)
    create index(:invitations, ["organization_id", "invitee_id"], unique: true)
  end
end