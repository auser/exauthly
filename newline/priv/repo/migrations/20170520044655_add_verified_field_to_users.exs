defmodule Newline.Repo.Migrations.AddVerifiedFieldToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :verified, :boolean, default: false
      add :verify_token, :string
    end

     create index(:users, ["verify_token"], unique: true)
  end
end
