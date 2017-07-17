# defmodule Newline.SocialAccounts do

#   alias Newline.Repo
#   alias Newline.Accounts.{User, SocialAccount}
#   alias Ueberauth.Auth

#   @doc """
#   Get or insert a user for their authorization
#   """
#   def find_or_create(auth, current_user) do
#     case auth_and_validate(auth) do
#       {:error, :not_found} -> register_user_from_auth(auth, current_user)
#       {:error, reason} -> {:error, reason}
#       auth ->
#         if auth.expires_at && auth.expires_at < Guardian.Utils.timestamp do
#           replace_authorization(authorization, auth, current_user)
#         else
#           user_from_authorization(authorization, current_user)
#         end
#     end
#   end

#   defp auth_and_validate(%{provider: service} = auth) when service in [:github] do
#     case Repo.get_by(SocialAccount, uid: uid_from_auth(auth), provider: to_string(auth.provider)) do
#       nil -> {:error, :not_found}
#       authorization ->
#         if authorization.uid == uid_from_auth(auth) do
#           authorization
#         else
#           {:error, :uid_mismatch}
#         end
#     end
#   end

#   defp auth_and_validate(auth) do
#     case Repo.get_by(SocialAccount, uid: uid_from_auth(auth), provider: to_string(auth.provider)) do

#     end
#   end

# end
