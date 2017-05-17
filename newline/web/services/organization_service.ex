defmodule Newline.OrganizationService do
  use Newline.Web, :service

  alias Newline.{Repo, Organization, OrganizationMembership, User}

  @doc """
  Create an organization
  """
  def create_org(current_user, params) do
    params = params |> Map.put(:user_id, current_user.id)
    changeset = Organization.create_changeset(%Organization{}, params)

    result = 
      insert(changeset, params)
      |> Repo.transaction()
    
    case result do
      {:ok, %{organization: organization}} ->
        org = Repo.get!(Organization, organization.id) ## Reload
        {:ok, org}
      {:error, _failed_op, changeset, _changes} ->  {:error, changeset}
    end
  end

  @doc """
  Insert a new organization membership by user_id
  1. adding the organization to the current changeset
  2. Adding the user (by "user_id") to the organization
  3. Setting the organization as the user's current organization
  """
  def insert(changeset, params) do
    Multi.new
    |> Multi.insert(:organization, changeset)
    |> Multi.run(:insert_orgmember, &(insert_orgmember(params[:user_id], &1[:organization], "owner")))
    |> Multi.run(:update_user_current_org, &(update_user_current_org(params[:user_id], &1[:organization])))
  end
  
  @doc """
  Get the owner of this group
  """
  def get_owner(%Organization{id: organization_id}) do
    query = from m in OrganizationMembership,
      where: m.organization_id == ^organization_id and m.role == "owner",
      join: u in User, where: u.id == m.member_id,
      select: u

    Repo.one(query)
  end
  def get_owner(_), do: nil

  @doc """
  Get members of a group
  """
  def get_members(%Organization{id: organization_id}) do
    query = from m in OrganizationMembership,
      where: m.organization_id == ^organization_id,
      order_by: [m.inserted_at],
      join: u in User, where: u.id == m.member_id,
      select: %{user: u, role: m.role}
    
    Repo.all(query)
  end
  def get_members(_), do: []

  def insert_orgmember(user_id, org, role \\ "member")
  def insert_orgmember(user_id, org, role) when is_integer(user_id) do
    OrganizationMembership.create_changeset(
      %OrganizationMembership{}, %{
        organization_id: org.id,
        member_id: user_id,
        role: role
      }
    )
    |> Repo.insert
    {:ok, org}
  end
  def insert_orgmember(user, org, role), do: insert_orgmember(user.id, org, role)

  defp update_user_current_org(user_id, org) do
    user = Repo.get!(User, user_id)
    User.update_changeset(user, %{
      current_organization_id: org.id
    })
    |> Repo.update
    {:ok, org}
  end
end