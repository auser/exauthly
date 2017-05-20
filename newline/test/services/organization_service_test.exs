defmodule Newline.OrganizationServiceTest do
  use ExUnit.Case, async: true

  use Newline.ModelCase
  import Newline.Factory
  import Newline.BasePolicy, only: [get_membership: 2]
  alias Newline.{OrganizationService, Repo}

  describe "create_org" do
    setup [:create_user, :create_organization]

    test "creates an organization with a name", %{org: org} do
      assert org.name === "Fullstack.io"
    end

    test "creates an organization with the user set as the owner", %{user: user, org: org} do
      membership = get_membership(org, user)
      assert membership.role === "owner"
    end

    test "fails when organization name has been taken", %{user: user, org: org} do
      {:error, _} = OrganizationService.create_org(user, %{name: org.name})
    end
  end

  describe "get_owner" do
    setup [:create_user, :create_organization]

    test "can get the owner", %{org: org, user: user} do
      owner = OrganizationService.get_owner(org)
      assert owner.id == user.id
      assert owner.email == user.email
    end

    test "gets owner with multiple users", %{org: org, user: user} do
      user1 = build(:user) |> Repo.insert!
      {:ok, _} = OrganizationService.insert_orgmember(user1.id, org)
      owner = OrganizationService.get_owner(org)
      assert owner.id == user.id
    end
  end

  describe "update a user role" do
    setup [:create_user, :create_organization]

    test "can update the user role", %{org: org, user: user} do
      refute get_membership(org, user).role == "admin"
      OrganizationService.update_orgrole(user, org, "admin")
      assert get_membership(org, user).role == "admin"
    end
  end

  describe "all_users_organization" do
    setup [:create_user, :create_organization]

    test "all_users_organization retrieves all the orgs the user belongs to", %{user: user} do
      other_org = build(:organization) |> Repo.insert!
      {:ok, orgs} = OrganizationService.all_users_organization(user)
      assert length(orgs) == 1
      OrganizationService.insert_orgmember(user, other_org)
      {:ok, orgs} = OrganizationService.all_users_organization(user)
      assert length(orgs) == 2
    end
  end

  describe "get_all" do
    setup [:create_admin, :create_user, :create_organization]

    test "get_all returns the user's organizations", %{user: user} do
      {:ok, orgs} = OrganizationService.get_all(user)
      assert length(orgs) == 1
      assert List.first(orgs).name == "Fullstack.io"

      org = build(:organization, %{name: "Frank"}) |> Repo.insert!
      OrganizationService.insert_orgmember(user, org)

      {:ok, orgs} = OrganizationService.get_all(user)
      assert length(orgs) == 2
    end

    test "get_all returns all organizations when the user is a site admin", %{admin: admin} do
      insert(:organization)
      insert(:organization)
      {:ok, orgs} = OrganizationService.get_all(admin)
      assert length(orgs) == 3
    end
  end

  describe "get_members" do
    setup [:create_user, :create_organization]

    test "gets list of users with their roles", %{user: user, org: org} do
      user1 = build(:user) |> Repo.insert!
      {:ok, reloaded} = OrganizationService.insert_orgmember(user1.id, org)
      members = OrganizationService.get_members(reloaded)
      assert length(members) == 2

      {:ok, member1} = Enum.fetch(members, 0)
      {:ok, member2} = Enum.fetch(members, 1)
      assert member1.role == "owner"
      assert member1.member.id == user.id
      assert member2.role == "member"
      assert member2.member.id == user1.id
    end
  end

  defp create_user(context) do
    user = build(:user) |> Repo.insert!
    Map.put(context, :user, user)
  end

  defp create_admin(context) do
    user = build(:user, %{admin: true, role: "admin", current_organization_id: nil}) |> Repo.insert!
    Map.put(context, :admin, user)
  end

  defp create_organization(%{user: user} = context) do
    {:ok, org} = OrganizationService.create_org(user, %{name: "Fullstack.io"})
    Map.put(context, :org, org)
  end
end
