defmodule Newline.UserResolver do
  import Newline.BaseResolver
  import Newline.BasePolicy, only: [site_admin?: 1]
  import Canada, only: [can?: 2]

  alias Newline.{User, Repo, UserService}
  
  @doc """
  Get all the users for a particular query
  """
  def all(_args, %{context: %{current_user: user}}) do
    can?(user, read User) and {:ok, user}
  end
  def all(_args, %{context: %{current_user: user, admin: true}}) do
    {:ok, Repo.all(User)}
  end
  def all(_, _), do: Newline.BaseResolver.unauthorized_error

  def create(params, _info) do
    UserService.user_signup(params) |> response
  end

  def login(params, _info) do
    UserService.user_login(params) |> response
  end

  def me(_args, %{context: %{current_user: user}}) do
    case can?(user, read user) do
      true -> UserService.user_profile(user) |> response
      false -> Newline.BaseResolver.unauthorized_error
    end
  end
  def me(_, _), do: Newline.BaseResolver.unauthorized_error
end