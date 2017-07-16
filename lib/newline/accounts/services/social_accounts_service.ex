defmodule Newline.SocialAccounts do

  alias Newline.Repo
  alias Newline.Accounts.{User,SocialAccount}
  alias Ueberauth.Auth

  def get_or_insert(auth, current_user, repo) do
    case auth_and_validate(auth, repo) do
      {:error, :not_found} -> register_user_from_auth(auth, current_user, repo)
      {:error, reason} -> {:error, reason}
      auth ->
        if auth.expires_at && auth.expires_at < Guardian.Utils.timestamp do
          replace_authorization(authorization, auth, current_user, repo)
        else
          user_from_authorization(authorization, current_user, repo)
        end
    end
  end

end
