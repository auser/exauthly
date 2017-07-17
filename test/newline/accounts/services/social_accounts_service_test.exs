# defmodule Newline.SocialAccountsTest do
#   use Newline.DataCase

#   import Newline.Factory
#   alias Newline.Accounts
#   alias Newline.Accounts.{User, SocialAccount}
#   alias Newline.Repo
#   alias Ueberauth.Auth
#   alias Ueberauth.Auth.{Credentials, Info}

#   describe "find_or_create" do
#     setup [:create_social_account]

#     test "creates a new authorization and user when neither exist", %{auth: auth} do
#       before_users = user_count()
#       before_auth = auth_count()
#       {:ok, user} = SocialAccount.find_or_create(auth, nil)
#       assert user_count() == before_users + 1
#       assert auth_count() == before_auth + 1
#     end
#   end


#   defp user_count, do: Repo.one(from u in User, select: count(u.id))
#   defp auth_count, do: Repo.one(from a in SocialAccount, select: count(a.id))

#   defp create_social_account(context) do
#     auth = %Auth{
#       provider: "github",
#       uid: "auser",
#       info: %Ueberauth.Auth.Info{
#         name: "ari",
#         email: "ari@fullstack.io"
#       },
#       credentials: %Ueberauth.Auth.Credentials{
#         token: "some-token",
#         refresh_token: "some-refresh-token",
#         expires_at: Guardian.Utils.timestamp + 1000
#       }
#     }
#     context
#     |> Map.put(:auth, auth)
#   end
# end
