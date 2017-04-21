defmodule Newline.BasePolicyTest do
  use Newline.ModelCase
  import Newline.Factory
  alias Newline.{BasePolicy, User, OrganizationMembership}

  setup do
    user = insert(:user)
    org = insert(:organization)

    {
      :ok, 
      valid_user: user,
      valid_org: org
    }
  end

  test "get_membership() is nil without a user" do
    assert BasePolicy.get_membership(nil, %User{}) == nil
  end

  test "get_membership() is true when user is a member of the organization", %{valid_org: org, valid_user: user} do
    membership_params = %{organization_id: org.id, member_id: user.id, role: "member"}
    cs = OrganizationMembership.create_changeset(%OrganizationMembership{}, membership_params)
    foundOrg = cs |> Repo.insert!
    assert BasePolicy.get_membership(cs, user) == foundOrg
  end

  test "get_membership() reveals membership when belongs to current organization", %{valid_org: org, valid_user: user} do
    changeset = User.update_changeset(user, %{current_organization_id: org.id})
    foundMembership = insert(:organization_membership, role: "member", member: user, organization: org)
    assert BasePolicy.get_membership(changeset, user).id == foundMembership.id
  end

  test "get_membership() finds membership when organization contains the user", %{valid_org: org, valid_user: user} do
    foundMembership = insert(:organization_membership, role: "member", member: user, organization: org)
    assert BasePolicy.get_membership(org, user).id == foundMembership.id
  end

  test "get_membership() finds no membership when the org does not contain the user", %{valid_org: org, valid_user: user} do
    assert BasePolicy.get_membership(org, user) == nil
  end

  test "get_role() returns nil without an organization" do
    assert BasePolicy.get_role(nil) == nil
  end
  test "get_role() returns the role in membership", %{valid_org: org, valid_user: user} do
    member = insert(:organization_membership, role: "member", member: user, organization: org)
    assert BasePolicy.get_role(member) == "member"
    member = OrganizationMembership.update_changeset(member, %{role: "admin"}) |> Repo.update!
    assert BasePolicy.get_role(member) == "admin"
    member = OrganizationMembership.update_changeset(member, %{role: "owner"}) |> Repo.update!
    assert BasePolicy.get_role(member) == "owner"
  end

  test "get_role() returns the role in the changeset", %{valid_org: org, valid_user: user} do
    member_cs = build(:organization_membership, role: "member", member_id: user.id, organization_id: org.id)
    assert BasePolicy.get_role(member_cs) == "member"
  end

  test "get role returns the user role for org", %{valid_org: org, valid_user: user} do
    insert(:organization_membership, role: "member", member: user, organization: org)
    assert BasePolicy.get_role(org, user) == "member"
  end

  test "get_role() returns nil if user is not in org", %{valid_org: org, valid_user: user} do
    assert BasePolicy.get_role(org, user) == nil
  end

  test "owner? returns true if user is owner of org when passed role", %{valid_org: org, valid_user: user} do
    membership = insert(:organization_membership, role: "owner", member: user, organization: org)
    assert BasePolicy.owner?(membership.role)
  end

  test "owner? returns false if anything else is passed" do
    refute BasePolicy.owner?("dogs") 
  end

  test "owner? returns true if user is owner of org when passed org and user", %{valid_org: org, valid_user: user} do
    insert(:organization_membership, role: "owner", member: user, organization: org)
    assert BasePolicy.owner?(org, user)
  end

  test "owner? returns false if user not is owner of org when passed org and user", %{valid_org: org, valid_user: user} do
    refute BasePolicy.owner?(org, user)
  end

  test "member?/1 returns true for any role in the organization", %{valid_org: org, valid_user: user} do
    member = insert(:organization_membership, role: "owner", member: user, organization: org)
    assert BasePolicy.member?(member.role)
    member = OrganizationMembership.update_changeset(member, %{role: "admin"}) |> Repo.update!
    assert BasePolicy.member?(member.role)
    member = OrganizationMembership.update_changeset(member, %{role: "member"}) |> Repo.update!
    assert BasePolicy.member?(member.role)
  end

  test "member?/1 returns false if anything else", %{valid_org: org, valid_user: user} do
    member = insert(:organization_membership, role: "banned", member: user, organization: org)
    refute BasePolicy.member?(member.role)
  end

  test "member?/2 returns true if any role in organization", %{valid_org: org, valid_user: user} do
    member = insert(:organization_membership, role: "member", member: user, organization: org)
    assert BasePolicy.member?(org, user)
    OrganizationMembership.update_changeset(member, %{role: "admin"}) |> Repo.update!
    assert BasePolicy.member?(org, user)
  end

  test "member?/2 returns false if not a role in organization", %{valid_org: org, valid_user: user} do
    refute BasePolicy.member?(org, user)
    insert(:organization_membership, role: "banned", member: user, organization: org)
    refute BasePolicy.member?(org, user)
  end

  test "at_least_admin?/1 returns true if the user is an admin or owner", %{valid_org: org, valid_user: user} do
    member = insert(:organization_membership, role: "admin", member: user, organization: org)
    assert BasePolicy.at_least_admin?(member.role)
    member = OrganizationMembership.update_changeset(member, %{role: "owner"}) |> Repo.update!
    assert BasePolicy.at_least_admin?(member.role)
  end

  test "at_least_admin?/1 returns false if the user is not include or just a member", %{valid_org: org, valid_user: user} do
    refute BasePolicy.at_least_admin?(nil)
    member = insert(:organization_membership, role: "member", member: user, organization: org)
    refute BasePolicy.at_least_admin?(member.role)
  end

  test "at_least_admin?/2 returns true if the user is an admin", %{valid_user: user, valid_org: org} do
    insert(:organization_membership, role: "admin", member: user, organization: org)
    assert BasePolicy.at_least_admin?(org, user)
  end

  test "at_least_admin?/2 returns true if the user is an owner", %{valid_user: user, valid_org: org} do
    insert(:organization_membership, role: "owner", member: user, organization: org)
    assert BasePolicy.at_least_admin?(org, user)
  end

  test "at_least_admin?/2 returns false if the user is not a member", %{valid_user: user, valid_org: org} do
    refute BasePolicy.at_least_admin?(org, user)
  end

  test "at_least_admin?/2 returns false if the user is just a member", %{valid_user: user, valid_org: org} do
    insert(:organization_membership, role: "member", member: user, organization: org)
    refute BasePolicy.at_least_admin?(org, user)
  end

  test "get_current_organization returns new current_organization when user is changing it", %{valid_user: user, valid_org: org} do
    changeset = User.update_changeset(user, %{current_organization_id: org.id})
    assert BasePolicy.get_current_organization(changeset) == org
  end

  test "get_current_organization returns new current_organization for a user", %{valid_user: user, valid_org: org} do
    user = User.update_changeset(user, %{current_organization_id: org.id}) |> Repo.update!
    assert BasePolicy.get_current_organization(user) == org
  end

  test "get_current_organization returns new current_organization when set", %{valid_org: org} do
    assert BasePolicy.get_current_organization(%{current_organization_id: org.id}) == org
  end

  test "get_current_organization() returns nil otherwise" do
    assert BasePolicy.get_current_organization(%{}) == nil
  end
end