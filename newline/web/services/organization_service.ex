defmodule Newline.OrganizationService do
  use Newline.Web, :service

  alias Newline.{Repo, Organization, OrganizationMembership, User}
  import Newline.BasePolicy, only: [get_membership: 2, site_admin?: 1]
  import Canada, only: [can?: 2]

  @doc """
  Get All the available organizations for a user

  User permissions are as follows.

  A admin user without a current org can see _all_ organizations
  A user with a current organization can list all their organizations)
  """
  def get_all(user) do
    cond do
      site_admin?(user) -> {:ok, Repo.all(Organization)}
      can?(user, list Organization) -> all_users_organization(user)
      false -> Newline.BaseService.unauthorized_error
    end
  end

  @doc """
  Create an organization
  """
  def create_org(current_user, params \\ %{}) do
    case site_admin?(current_user) or can?(current_user, create Organization) do
      true -> do_create_org(current_user, params)
      false -> Newline.BaseService.unauthorized_error
    end
  end

  defp do_create_org(current_user, params \\ %{}) do
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

  # @doc """
  # Get the membership for a user
  # """
  # def get_membership(%User{id: user_id}, %Organization{id: org_id}) do
  #   from m in OrganizationMembership
  #     where: m.organization_id == ^organization_id and m.member_id == ^user_id,
  #   |> Repo.all
  # end

  @doc """
  Get members of a group
  """
  def get_members(%Organization{id: organization_id}) do
    query = from m in OrganizationMembership,
      where: m.organization_id == ^organization_id,
      order_by: [m.inserted_at],
      preload: [:member],
      join: u in User, where: u.id == m.member_id
      # select: %{user: u, role: m.role}
    
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

  @doc """
  Get all the organizations a user belongs to
  """
  def all_users_organization(%User{id: user_id}) do
    query = from m in OrganizationMembership,
      where: m.member_id == ^user_id,
      # preload: [:organization, :member],
      join: org in Organization, where: org.id == m.organization_id,
      select: org
    
    {:ok, Repo.all(query)}
  end

  @doc """
  Update the user's role'
  """
  def update_orgrole(%User{} = user, %Organization{} = org, role \\ "member") do
    case get_membership(org, user) do
      nil -> {:error, :not_found}
      membership ->
        org = OrganizationMembership.update_changeset(membership, %{role: role}) |> Repo.update
        {:ok, org}
    end
  end

  @doc """
  Update a user's current organization
  
  Example

      iex> OrganizationService.update_user_current_org(user, org)
  """
  def update_user_current_org(user, nil), do: nil
  def update_user_current_org(user_id, org) when is_number(user_id), do: update_user_current_org(Repo.get(User, user_id), org)
  def update_user_current_org(%User{} = user, org) do
    User.update_changeset(user, %{
      current_organization_id: org.id
    }) |> Repo.update
  end
end