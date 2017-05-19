defmodule Newline.MembershipServiceTest do
  use ExUnit.Case, async: true

  use Newline.ModelCase
  import Newline.Factory
  # import Newline.BasePolicy, only: [get_membership: 2]
  alias Newline.{MembershipService, OrganizationService, User, Repo}

  describe "Membership" do
    setup [:create_user, :create_organization]
    setup %{user: user} = context do
      owner = build(:user) |> Repo.insert!
      other_user = build(:user) |> Repo.insert!
      {:ok, other_org} = OrganizationService.create_org(owner, %{name: "Bob burgers'"})
      {:ok, another_org} = OrganizationService.create_org(other_user, %{name: "Simple"})
      OrganizationService.insert_orgmember(user, other_org)
      context
        |> Map.put(:owner, owner)
        |> Map.put(:other_org, other_org)
        |> Map.put(:other_user, other_user)
        |> Map.put(:another_org, another_org)
    end

    test "finds the user membership for a given organization", %{user: user, org: org} do
      assert MembershipService.user_membership_for(user, org).role == "owner"
    end

    test "finds the user membership as a member", %{other_org: other_org, user: user} do
      assert MembershipService.user_membership_for(user, other_org).role == "member"
    end

    test "returns nil if there is no relationship between the org and user", %{user: user, another_org: org} do
      assert MembershipService.user_membership_for(user, org) == nil
    end
  end

  defp create_user(context) do
    user = build(:user) |> Repo.insert!
    Map.put(context, :user, user)
  end

  defp create_organization(%{user: user} = context) do
    {:ok, org} = OrganizationService.create_org(user, %{name: "Fullstack.io"})
    Map.put(context, :org, org)
  end

  # defp create_membership(%{user: user, org: org} = context) do
  #   {:ok, membership} = OrganizationService.insert_orgmember(user, org)
  #   Map.put(context, :membership, membership)
  # end

end