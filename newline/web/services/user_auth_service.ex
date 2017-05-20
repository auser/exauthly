defmodule Newline.UserAuthService do
  use Newline.Web, :service

  alias Newline.{Repo, User}
  alias Newline.{Authorization}

  def get_or_insert(auth) do
    case auth_and_validate(auth) do
      {:error, :not_found} -> register_user_from_auth(auth)
      {:error, reason} -> {:error, reason}
      {:ok, user} -> {:ok, user}
      authorization -> user_from_authorization(authorization, auth)
    end
  end

  def auth_and_validate(auth) do
    case Repo.get_by(Authorization, uid: auth.uid, provider: to_string(auth.provider)) do
      nil -> {:error, :not_found}
      auth -> auth
    end
  end

  defp user_from_authorization(authorization, auth) do
    case Repo.one(Ecto.assoc(authorization, :user)) do
      nil -> {:error, :user_not_found}
      user ->
        update_authorization(authorization, auth)
        {:ok, user}
    end
  end

  defp register_user_from_auth(auth) do
    case Repo.transaction(create_user_from_auth(auth)) do
      {:ok, %{user: user, authorization: _authorization}} -> {:ok, user}
      {:error, _failed_op, _failed_value, _changes} -> {:error, :transaction_failed}
    end
  end

  defp create_user_from_auth(auth) do
    params = scrub(%{
      email: auth.info.email,
      name: auth.info.name,
    })
    Multi.new
    |> Multi.insert(:user, User.changeset(%User{}, params))
    |> Multi.run(:authorization, &insert_authorization(auth, &1[:user]))
    # TODO: Send welcome email
  end

  defp insert_authorization(auth, user) do
    authorization = Ecto.build_assoc(user, :authorizations)
    params = scrub(%{
      provider: to_string(auth.provider),
      uid: auth.uid,
      token: to_string(auth.credentials.token),
      refresh_token: to_string(auth.credentials.refresh_token),
      expires_at: auth.credentials.expires_at
    })
    Repo.insert Authorization.changeset(authorization, params)
  end

  defp update_authorization(authorization, auth) do
    params = scrub(%{
      token: to_string(auth.credentials.token),
      refresh_token: to_string(auth.credentials.refresh_token),
      expires_at: auth.credentials.expires_at
    })
    Repo.update Authorization.changeset(authorization, params)
  end

  defp scrub(params) do
    Enum.filter(params, fn
      {_, val} when is_binary(val) -> String.strip(val) != ""
      {_, val} when is_nil(val) -> false
      _ -> true
    end) |> Enum.into(%{})
  end


end
