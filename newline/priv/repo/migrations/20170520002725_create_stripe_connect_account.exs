defmodule Newline.Repo.Migrations.CreateStripeConnectAccount do
  use Ecto.Migration

  def change do
    create table(:stripe_connect_accounts) do
      add :business_name, :string
      add :business_url, :string
      add :charges_enabled, :boolean, default: true, null: false
      add :country, :string
      add :default_currency, :string, default: "USD"
      add :display_name, :string
      add :email, :string
      add :stripe_id, :string, null: false
      add :support_email, :string
      add :support_phone, :string

      add :tos_acceptance_date, :utc_datetime
      add :verification_due_by, :utc_datetime

      add :organization_id, references(:organizations), null: false

      timestamps()
    end

    create unique_index(:stripe_connect_accounts, [:stripe_id])
    create unique_index(:stripe_connect_accounts, [:organization_id])

  end
end
