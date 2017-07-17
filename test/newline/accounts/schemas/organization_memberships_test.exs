defmodule Newline.OrganizationMembershipTest do
  use Newline.SchemaCase
  import Newline.Factory
  alias Newline.Repo
  alias Newline.Accounts.OrganizationMembership

  describe "create_changeset/2" do
    setup [:create_organization, :create_user]
    test "creates a membership with org and user", %{user: user, org: org} do
      params = %{
        organization_id: org.id,
        member_id: user.id
      }
      cs = OrganizationMembership
            .create_changeset(%OrganizationMembership{}, params)
      assert cs.valid?
      assert cs.changes.role == "member"
    end

    test "creates a membership with defined role", %{user: user, org: org} do
      params = %{
        organization_id: org.id,
        member_id: user.id,
        role: "owner"
      }
      cs = OrganizationMembership
            .create_changeset(%OrganizationMembership{}, params)
      assert cs.valid?
      assert cs.changes.role == "owner"
    end

    test "invalid without an organization", %{user: user} do
      params = %{
        member_id: user.id
      }
      cs = OrganizationMembership
            .create_changeset(%OrganizationMembership{}, params)
      refute cs.valid?
    end

    test "invalid without a member", %{org: org} do
      params = %{
        organization_id: org.id
      }
      cs = OrganizationMembership
            .create_changeset(%OrganizationMembership{}, params)
      refute cs.valid?
    end

    test "invalid without invalid role", %{user: user, org: org} do
      params = %{
        organization_id: org.id,
        member_id: user.id,
        role: "theman"
      }
      cs = OrganizationMembership
            .create_changeset(%OrganizationMembership{}, params)
      refute cs.valid?
    end

    test "cannot have a user with more than one membership", %{org: org, user: user} do
      params = %{
        organization_id: org.id,
        member_id: user.id,
        role: "member"
      }
      OrganizationMembership
          .create_changeset(%OrganizationMembership{}, params)
      |> Repo.insert!

      cs = OrganizationMembership
            .create_changeset(%OrganizationMembership{}, params)
      {:error, _} = cs |> Repo.insert
    end
  end

  defp create_organization(context) do
    context
    |> Map.put(:org, insert(:organization))
  end

  defp create_user(context) do
    context
    |> Map.put(:user, insert(:user))
  end
end
