defmodule Newline.Repo.Migrations.CreateSocialAccounts do
  use Ecto.Migration

  def change do
    create table(:social_accounts) do
      add :social_account_name, :string, null: false
      add :social_account_id, :string, null: false

      add :auth_token, :string
      add :refresh_token, :string

      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :login_name, :string

      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:social_accounts, [:social_account_name, :user_id], name: :social_account_name_to_user_id_index, unique: true)
  end
end
