defmodule Newline.OrganizationResolverTest do
  use Newline.ModelCase
  use Newline.GqlCase
  # import Newline.AssertResult
  import Newline.Factory
  alias Newline.{OrganizationResolver, Schema, OrganizationService}

  setup do
    user = insert(:user)
    org = insert(:organization)
    insert(:organization_membership, role: "owner", member: user, organization: org)
    {
      :ok, 
      current_user: user,
      context: %{context: %{ current_user: user }},
      valid_org: org
    }
  end

  test "all/2 returns undefined without user" do
    assert OrganizationResolver.all(:something, %{}) == {:error, "Unauthorized"}
  end

  test "all/2 returns all organizations for site admins", %{valid_org: org} do
    insert(:organization)
    admin = insert(:user, admin: true)
    context = %{context: %{current_user: admin, admin: true}}
    {:ok, orgs} = OrganizationResolver.all(:type, context)
    assert length(orgs) == 2
    assert Enum.at(orgs, 0).id == org.id
  end

  describe "all" do
    setup [:create_user, :create_admin]
    @query """
    {
      organizations {
        name
      }
    }
    """

    test "it lists all the organizations for site admins", %{admin: user} do
      insert(:organization, %{name: "jake's shake shack"})
      {:ok, %{data: %{"organizations" => organizations}}} =
        @query |> run(Schema, context: %{current_user: user})

      assert length(organizations) == 2
    end

    test "it lists a user's organization list", %{user: user} do
      org = build(:organization, %{name: "jake's shake shack"}) |> Repo.insert!
      {:ok, _} = OrganizationService.insert_orgmember(user, org)
      {:ok, _} = OrganizationService.update_user_current_org(user, org)

      {:ok, %{data: %{"organizations" => organizations}}} =
        @query |> run(Schema, context: %{current_user: user})

      assert length(organizations) == 1
      assert List.first(organizations)["name"] == "jake's shake shack"
    end
  end

  describe "create_organization" do
    setup [:create_user]
    @query """
    mutation create_org($name:String!) {
      create_organization(name:$name) {
        name
        slug
      }
    }
    """

    test "it creates an organization", %{user: user} do
      {:ok, %{data: %{"create_organization" => %{"name" => "bob's burgers", "slug" => "bob's-burgers"}}}} = 
        @query |> run(Schema, variables: %{"name" => "bob's burgers"}, context: %{current_user: user})
    end

    test "it fails without a current user" do
      {:ok, %{data: %{"create_organization" => nil}, errors: [h|_]}} = 
        @query |> run(Schema, variables: %{"name" => "something"}, context: %{current_user: nil})
      
      assert h.message == "In field \"create_organization\": Unauthorized"
    end
  end

  describe "switch current organization" do
    setup [:create_user, :create_org]

    @query """
    mutation set_current_organization($org_id:Int) {
      setCurrentOrganization(org_id:$org_id) {
        id
        name
      }
    }
    """

    test "returns the user's current organization", %{user: user} do
      org = build(:organization, %{name: "jake's shake shack"}) |> Repo.insert!
      {:ok, _} = OrganizationService.insert_orgmember(user, org)
      {:ok, _} = OrganizationService.update_user_current_org(user, org)

      {:ok, %{data: %{"setCurrentOrganization" => %{"id" => id, "name" => _name}}}} =
        @query |> run(Schema, variables: %{"org_id" => org.id}, context: %{current_user: user})

      assert id == to_string(org.id)
    end
  end

  defp create_user(context) do
    password = "testing"
    user = build(:user) |> Repo.insert!
    context
      |> Map.put(:user, user)
      |> Map.put(:password, password)
  end

  defp create_admin(context) do
    user = build(:user, %{admin: true, role: "admin", current_organization_id: nil}) |> Repo.insert!
    Map.put(context, :admin, user)
  end

  defp create_org(context) do
    org = build(:organization) |> Repo.insert!
    Map.put(context, :org, org)
  end

end