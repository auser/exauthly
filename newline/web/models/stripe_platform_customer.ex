defmodule Newline.StripePlatformCustomer do
  use Newline.Web, :model

  schema "stripe_platform_customers" do
    field :created, :integer
    field :string, :integer
    field :currency, :string
    field :delinquent, :boolean, default: false
    field :email, :string
    field :stripe_id, :string

    belongs_to :user, Newline.User

    has_many :stripe_connect_customers, Newline.StripeConnectCustomer

    timestamps()
  end

  @valid_params [
    :currency, :created, :delinquent, :stripe_id
  ]
  @required_params [
    :stripe_id
  ]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @valid_params ++ @required_params)
    |> validate_required(@required_params)
    |> assoc_constraint(:user)
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
  end
end
