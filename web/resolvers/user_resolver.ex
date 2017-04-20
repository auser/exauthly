defmodule Newline.UserResolver do
  import Newline.BaseResolver, only: [response: 1]
  import Newline.BasePolicy, only: [site_admin?: 1]

  alias Newline.{User, Repo, UserService}
  
  def all(_args, %{context: %{current_user: user, admin: true}}) when not is_nil(user) do
    {:ok, Repo.all(User)}
  end
  def all(_args, %{context: %{current_user: user}}) when not is_nil(user) do
    {:ok, user}
  end
  def all(_, _), do: {:error, "Unauthorized"}

  def create(params, _info) do
    UserService.user_signup(params) |> response
  end

  def login(params, _info) do
    UserService.user_login(params) |> response
  end
end