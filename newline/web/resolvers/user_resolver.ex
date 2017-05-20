defmodule Newline.UserResolver do
  import Newline.BaseResolver
  import Newline.BasePolicy
  import Canada, only: [can?: 2]

  alias Newline.{User, Repo, UserService, OrganizationService}
  
  @doc """
  Get all the users for a particular query

  A user can see _all_ the users of an organization if they are 
  the owner or the administrator of the group. They can also see all the
  members for _every_ group when there is no current organization _and_ they
  are marked as a global administrator.

  A user without a role cannot list anything
  """
  def all(_args, %{context: %{current_user: _, current_org: nil, admin: true}}) do
    {:ok, Repo.all(User)}
  end
  def all(_, %{context: %{role: nil}}), do: Newline.BaseResolver.unauthorized_error
  def all(_args, %{context: %{current_user: user, current_org: org, role: role, admin: false}}) do
    cond do
      can?(user, read org) -> {:ok, OrganizationService.get_members(org)}
      false -> Newline.BaseResolver.unauthorized_error
    end
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