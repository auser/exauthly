defmodule Newline.OrganizationMembership do
  @moduledoc """
  A user's membership in an org'
  """

  use Newline.Web, :model

  alias Newline.{User, Organization}

  schema "organization_memberships" do
    field :role, :string

    belongs_to :organization, Organization
    belongs_to :member, User

    timestamps()
  end

  @doc """
  Builds a changeset for adding a member to 
  this organization.
  """
  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:member_id, :organization_id, :role])
    |> validate_required([:member_id, :organization_id, :role])
    |> assoc_constraint(:member)
    |> assoc_constraint(:organization)
    |> validate_inclusion(:role, roles())
  end

  @doc """
  Builds changeset for updating membership
  """
  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:role])
    |> validate_required([:role])
    |> validate_inclusion(:role, roles())
  end

  # Possible roles
  def roles do
    ~w{ owner admin manager member }
  end
end