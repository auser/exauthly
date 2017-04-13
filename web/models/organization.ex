defmodule Newline.Organization do
  use Newline.Web, :model

  alias Newline.{OrganizationMembership}

  schema "organizations" do
    field :name, :string

    has_many :organization_memberships, OrganizationMembership
    has_many :members, through: [:organization_memberships, :member]

    timestamps()
  end

  @required_fields ~w(name)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
  end

  @doc """
  Create an organization
  """
  def create_changeset(org, params \\ %{}) do
    org
    |> cast(params, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 255)
  end

  @doc """
  Update an organization
  """
  def update_changeset(org, params \\ %{}) do
    org
    |> cast(params, [:name])
  end
end