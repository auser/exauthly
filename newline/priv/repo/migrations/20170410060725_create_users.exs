defmodule Newline.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string, null: false

      add :password, :string, virtual: true
      add :encrypted_password, :string

      add :password_reset_token, :string
      add :password_reset_timestamp, :utc_datetime

      add :admin, :boolean, default: false
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
