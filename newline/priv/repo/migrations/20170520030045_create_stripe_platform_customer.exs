defmodule Newline.Repo.Migrations.CreateStripePlatformCustomer do
  use Ecto.Migration

  def change do
    create table(:stripe_platform_customers) do
      add :currency, :string
      add :delinquent, :boolean, default: false, null: false
      add :email, :string
      add :stripe_id, :string

      timestamps()
    end

  end
end
