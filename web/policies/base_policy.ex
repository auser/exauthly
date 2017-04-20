defmodule Newline.BasePolicy do
  @moduledoc """
  Holds helpers for extracting record relationships
  """

  import Ecto.Query
  alias Ecto.Changeset

  alias Newline.{Repo, Organization, User, OrganizationMembership}

  @doc """
  Get the user's memberhsip record, from Changeset containing :organization_id'
  """
  def get_membership(nil, %User{}), do: nil
  def get_membership(%Changeset{changes: %{organization_id: organization_id}}, %User{id: user_id}) do
    handle_get_membership(organization_id, user_id)
  end
  def get_membership(%Changeset{changes: %{current_organization_id: current_organization_id}}, %User{id: user_id}) do
    handle_get_membership(current_organization_id, user_id)
  end
  def get_membership(%Organization{id: organization_id}, %User{id: user_id}) do
    handle_get_membership(organization_id, user_id)
  end
  defp handle_get_membership(organization_id, user_id) do
    OrganizationMembership
    |> where([m], m.member_id == ^user_id and m.organization_id == ^organization_id)
    |> Repo.one
  end

  @doc """
  Get the role from an OrganizationMembership or Changeset
  """
  def get_role(nil), do: nil
  def get_role(%OrganizationMembership{role: role}), do: role
  def get_role(%Changeset{} = changeset), do: Changeset.get_field(changeset, :role)

  def get_role(%Organization{id: organization_id}, %User{id: user_id}) do
    membership = handle_get_membership(organization_id, user_id)
    membership && membership.role
  end
  def get_role(_, _), do: nil

  @doc """
  Is the user an admin
  """
  def site_admin?(%User{admin: true}), do: true
  def site_admin?(_), do: false

  @doc """
  Is a user the owner
  """
  def owner?("owner"), do: true
  def owner?(_), do: false

  @doc """
  Is a user owner of the organization
  """
  def owner?(%Organization{} = org, %User{} = user) do
    get_role(org, user) == "owner"
  end
  def owner?(_, _), do: false

  @doc """
  Is a user a member of an organization
  """
  def member?(role) when role in ~w{ owner admin manager member }, do: true
  def member?(_), do: false

  @doc """
  Is user a member of the organization
  """
  def member?(%Organization{} = org, %User{} = user) do
    member?(get_role(org, user))
  end
  def member?(_, _), do: false

  @doc """
  Is a user an admin or owner
  """
  def at_least_admin?(role) when role in ["admin", "owner"], do: true
  def at_least_admin?(_), do: false

  @doc """
  Is the user at least an admin in organization
  """
  def at_least_admin?(%Organization{} = org, %User{} = user) do
    at_least_admin?(get_role(org, user))
  end
  def at_least_admin?(_, _), do: false

  @doc """
  Get the current organization for a user and user changeset
  """
  def get_current_organization(%{current_organization_id: current_organization_id}) do
    Repo.get(Organization, current_organization_id)
  end
  def get_current_organization(%User{current_organization_id: current_organization_id}) do
    Repo.get(Organization, current_organization_id)
  end
  def get_current_organization(%Changeset{changes: %{current_organization_id: current_organization_id}}) do
    Repo.get(Organization, current_organization_id)
  end
  def get_current_organization(_), do: nil
end