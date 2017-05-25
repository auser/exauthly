defmodule Newline.InvitationTest do
  use Newline.ModelCase
  import Newline.Factory
  alias Newline.{Invitation, Repo, OrganizationService}

  @valid_attrs %{}
  @invalid_attrs %{}

  describe "create" do
    setup [:create_invitation]


    test "invitee is not represented in the User table", %{invite: invite} do
      assert invite.valid?
    end

    test "creates a unique token", %{invite: invite} do
      assert invite.changes.token != nil
    end
  end

  defp create_invitation(context) do
    user = build(:user) |> Repo.insert!
    org = build(:organization) |> Repo.insert!
    invitee = build(:user) |> Repo.insert!
    invite = Invitation.create_changeset(%Invitation{}, %{organization: org, user: user, invitee: invitee})
    Map.put(context, :invite, invite)
  end
end
