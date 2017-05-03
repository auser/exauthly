defmodule Newline.Organization do
  use Newline.Web, :model

  alias Newline.{OrganizationMembership}

  schema "organizations" do
    field :name, :string

    has_many :organization_memberships, OrganizationMembership
    has_many :members, through: [:organization_memberships, :member]

    timestamps()
  end

  @doc """
  Create an organization

  ## Examples

    iex> Organization.create_changeset(%Newline.Organization{}, %{name: "Fullstack.io"})
  """
  @spec create_changeset(struct, map) :: Ecto.Changeset
  def create_changeset(org, params \\ %{}) do
    org
    |> cast(params, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 255)
    |> unique_constraint(:name, message: "Organization name already taken")
  end

  @doc """
  Update an organization
  """
  def update_changeset(org, params \\ %{}) do
    org
    |> cast(params, [:name])
  end

  @doc """
  Get the organization owner
  """
  
end