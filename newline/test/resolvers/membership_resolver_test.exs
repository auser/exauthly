defmodule Newline.MembershipResolverTest do
  use Newline.ModelCase
  use Newline.GqlCase
  import Newline.AssertResult
  import Newline.Factory
  alias Newline.{Schema, OrganizationService, MembershipService}

  describe "all" do
    setup [:create_user, :another_user]

    @query """
    {
      memberships {
        role
        organization {
          name
        }
      }
    }
    """

    test "returns the id and role for memberships a user belongs to (one org)", %{user: user, another_user: u2} do
      {:ok, org} = OrganizationService.create_org(user, %{name: "Soemthing fun"})
      {:ok, _} = OrganizationService.create_org(u2, %{name: "another org"})

      assert_result {:ok, %{data: %{"memberships" => [%{"role" => "owner", "organization" => %{"name" => "Soemthing fun"}}] }}}, 
        @query |> run(Schema, context: %{current_user: user})
    end
  end

  defp create_user context do
    user = build(:user) |> Repo.insert!
    {:ok, Map.put(context, :user, user)}
  end

  defp another_user(context) do
    user = build(:user) |> Repo.insert!
    {:ok, Map.put(context, :another_user, user)}
  end
end