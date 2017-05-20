defmodule Newline.StripeExternalAccount do
  use Newline.Web, :model

  schema "stripe_external_accounts" do
    field :stripe_id, :string, null: false
    field :account_id_from_stripe, :string, null: false

    field :account_holder_name, :string
    field :account_holder_type, :string

    field :bank_name, :string
    field :country, :string
    field :currency, :string
    field :fingerprint, :string
    field :last4, :string
    field :routing_number, :string
    field :status, :string

    belongs_to :stripe_connect_account, Newline.StripeConnectAccount

    timestamps()
  end

  @create_params [
    :stripe_id, :account_id_from_stripe,
    :account_holder_name, :account_holder_type, :bank_name,
    :country, :currency, :fingerprint, :last4,
    :routing_number, :status, :stripe_connect_account_id
  ]

  @required_create_params [
    :stripe_id, :account_id_from_stripe
  ]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @create_params)
    |> validate_required(@required_create_params)
    |> assoc_constraint(:stripe_connect_account)
  end
end
