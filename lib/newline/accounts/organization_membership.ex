defmodule Newline.Accounts.OrganizationMembership do
  @moduledoc """
  A user's membership in an org'
  """
  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Newline.Repo
  alias Newline.Accounts.{User, Organization}

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
    |> validate_required([:member_id, :organization_id])
    |> assoc_constraint(:member)
    |> assoc_constraint(:organization)
    |> unique_constraint(:unique_membership, name: :organization_membership_unique_constraint_on_membership)
    |> set_role_if_necessary(:role)
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

  @doc """
  Possible roles available
  """
  def roles do
    ~w{ owner admin manager member }
  end

  defp set_role_if_necessary(changeset, role_key) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: changes} ->
        case Map.fetch(changes, role_key) do
          {:ok, _} ->
            changeset
          _ ->
            Ecto.Changeset.put_change(changeset, role_key, "member")
        end
      _ -> changeset
    end
  end
end
