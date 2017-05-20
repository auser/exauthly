defmodule Newline.OrganizationResolverTest do
  use Newline.ModelCase
  use Newline.GqlCase
  # import Newline.AssertResult
  import Newline.Factory
  alias Newline.{OrganizationResolver, Schema}

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

  test "all/2 returns only the organizations a user belongs to", %{context: context, valid_org: org} do
    {:ok, orgs} = OrganizationResolver.all(:type, context)
    %{current_organization: _current_organization, organizations: organizations} = orgs
    assert length(organizations) == 1
    assert Enum.at(organizations, 0).name == org.name
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

  defp create_user(context) do
    password = "testing"
    user = build(:user) |> Repo.insert!
    context
      |> Map.put(:user, user)
      |> Map.put(:password, password)
  end


end