defmodule Newline.MembershipServiceTest do
  use ExUnit.Case, async: true

  use Newline.ModelCase
  import Newline.Factory
  # import Newline.BasePolicy, only: [get_membership: 2]
  alias Newline.{OrganizationService, Repo}

  describe "Membership" do
    setup [:create_user, :create_organization, :create_membership]
  end

  defp create_user(context) do
    user = build(:user) |> Repo.insert!
    Map.put(context, :user, user)
  end

  defp create_organization(%{user: user} = context) do
    {:ok, org} = OrganizationService.create_org(user, %{name: "Fullstack.io"})
    Map.put(context, :org, org)
  end

  defp create_membership(%{user: user, org: org} = context) do
    {:ok, membership} = OrganizationService.insert_orgmember(user, org)
    Map.put(context, :membership, membership)
  end

end