defmodule Newline.InvitationResolverTest do
  use Newline.ModelCase
  use Newline.GqlCase
  # import Newline.AssertResult
  import Newline.Factory
  alias Newline.{Schema, InvitationResolver, User, OrganizationService}

  describe "invite_user" do
    setup [:create_user]

    @query """
    mutation inviteUser($email:Email!) {
      inviteUser(email:$email) {
        user {
          id
        }
        invitee {
          id
        }
      }
    }
    """

    test "creates an invitation with valid email", %{user: user} do
      {:ok, %{data: %{"inviteUser" => data}}} = @query |> run(Newline.Schema, 
        variables: %{"email" => "bob@bob.com"}, context: %{current_user: user})
      assert data["user"] == %{"id" => to_string(user.id)}
      invitee = Repo.get_by(User, email: "bob@bob.com")
      assert data["invitee"]["id"] == to_string(invitee.id)
    end
  end
  
  defp create_user(context) do
    password = "testing"
    user = build(:user) |> Repo.insert!
    org = build(:organization) |> Repo.insert!
    {:ok, org} = OrganizationService.update_user_current_org(user, org)
    user = Repo.get_by(User, email: user.email)
    context
      |> Map.put(:user, user)
      |> Map.put(:password, password)
      |> Map.put(:org, org)
  end
end