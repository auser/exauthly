defmodule Newline.AuthResolver do
  import Newline.BaseResolver
  # import Canada, only: [can?: 2]

  alias Newline.{UserService, User}

  def request_reset_password(%{email: email}, _) do
    case UserService.request_password_reset(email) do
      {:ok, _} -> {:ok, %{success: true}}
      _ -> {:ok, %{success: false}}
    end
  end

  def reset_password(%{password: password, token: token}, _) do
    case UserService.reset_password(token, password) do
      {:ok, user, token, _ } -> {:ok, Map.put(user, :token, token)}
      otherwise -> otherwise
    end
  end
end
