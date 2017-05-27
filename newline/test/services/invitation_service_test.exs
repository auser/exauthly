defmodule InvitationServiceTest do
  use Newline.ModelCase
  import Newline.Factory
  alias Newline.{InvitationService, Repo, User, Organization, Invitation}


  describe "invite_user_by_email_to_org" do
    setup [:create_invitation_things]

    test "works with unique email, user, and org", %{user: user, org: org} do
      email = "some@email.com"
      {:ok, invite} = InvitationService.invite_user_by_email_to_organization(email, user, org)

      assert invite.id != nil
      assert invite.organization != nil
      assert invite.user != nil
      assert invite.token != nil
    end

    test "is invalid with invalid email", %{user: user, org: org} do
      email = "not_valid"
      {:error, cs} = InvitationService.invite_user_by_email_to_organization(email, user, org)

      refute cs.valid?
      assert [email: {"has invalid format", _}] = cs.errors
    end

    test "with a user already registered", %{user: user, org: org} do
      invitee = build(:user) |> Repo.insert!
      {:ok, inv} = InvitationService.invite_user_by_email_to_organization(invitee.email, user, org)
      assert inv.id != nil
      assert inv.user != nil
    end
  end

  defp create_invitation_things(context) do
    user = build(:user) |> Repo.insert!
    org = build(:organization) |> Repo.insert!

    {:ok, context
            |> Map.put(:user, user)
            |> Map.put(:org, org)}
  end
end