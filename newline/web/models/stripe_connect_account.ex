defmodule Newline.StripeConnectAccount do
  use Newline.Web, :model

  schema "stripe_connect_accounts" do
    field :business_name, :string
    field :business_url, :string
    field :charges_enabled, :boolean, default: false

    field :country, :string
    field :default_currency, :string, default: "USD"
    field :display_name, :string
    field :email, :string

    field :tos_acceptance_date, :utc_datetime
    field :tos_acceptance_ip, :string
    field :tos_acceptance_user_agent, :string

    field :verification_due_by, :utc_datetime

    field :stripe_id, :string, null: false
    field :support_email, :string
    field :support_phone, :string

    belongs_to :organization, Newline.Organization
    # has_one :stripe_external_account, Newline.StripeExternalAccount

    timestamps()
  end

  @insert_params [
    :stripe_id, :organization_id
  ]

  @stripe_params [
    :business_name,
    :business_url, :charges_enabled,
    :country, :default_currency, :display_name,
    :email, :support_email, :support_phone,

    :tos_acceptance_date, :tos_acceptance_ip, 
    :tos_acceptance_user_agent
  ]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def create_changeset(struct, params \\ %{}) do
    valid_params = @insert_params ++ @stripe_params
    changeset = struct
    |> cast(params, valid_params)
    |> validate_required([:stripe_id, :organization_id, :tos_acceptance_date])
    |> assoc_constraint(:organization)
  end

  def webhook_update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @stripe_params)
  end
end
