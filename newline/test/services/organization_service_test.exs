defmodule Newline.OrganizationServiceTest do
  use Newline.ModelCase
  import Newline.Factory
  import Newline.BasePolicy, only: [get_membership: 2]
  alias Newline.{OrganizationService, Repo}

  describe "create_org" do
    setup do
      user = build(:user) |> Repo.insert!
      {:ok, org} = OrganizationService.create_org(user, %{name: "Fullstack"})
      %{user: user, org: org}
    end

    test "creates an organization with a name", %{org: org} do
      assert org.name === "Fullstack"
    end

    test "creates an organization with the user set as the owner", %{user: user, org: org} do
      membership = get_membership(org, user)
      assert membership.role === "owner"
    end

    test "fails when organization name has been taken", %{user: user, org: org} do
      {:error, _} = OrganizationService.create_org(user, %{name: org.name})
    end

  end
end