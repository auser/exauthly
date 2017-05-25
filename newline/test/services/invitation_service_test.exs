defmodule InvitationServiceTest do
  use Newline.ModelCase
  import Newline.Factory
  alias Newline.{InvitationService, Repo, User, Organization, Invitation}


  describe "invite_user_by_email_to_org" do
    setup [:create_invitation_things]

    test "works with unique email, user, and org", %{user: user, org: org} do
      email = "some@email.com"
      {:ok, invite} = InvitationService.invite_user_by_email_to_organization(email, user, org)

      assert invite.organization != nil
      assert invite.user != nil
      assert invite.token != nil

      IO.inspect invite
      IO.inspect Repo.get(Invitation, invite.id)
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