defmodule Newline.UserPolicy do
  import Newline.BasePolicy, only: [member?: 2, member?: 1, get_role: 1, get_membership: 2]

  alias Newline.{User, Organization}
  alias Ecto.Changeset

  defimpl Canada.Can, for: User do
    # User can do all the actions they want on themselves
    def can?(%User{id: user_id}, action, %User{id: user_id})
      when action in [:update, :read, :show, :edit], do: true
    # User can read their own organizations
    def can?(%User{} = user, :read, %Organization{} = org), do: member?(org, user)
    # An admin can do anything
    def can?(%User{admin: admin} = user, _, _), do: admin

    # Anything else, reject
    def can?(_, _, _), do: false
  end

  @doc """
  Can a user change current_organization_id
  """
  def update(%User{} = current_user, %Changeset{changes: %{current_organization_id: _current_organization_id}, data: %User{} = user} = changeset) do
    owner = current_user.id == user.id
    member = changeset
      |> get_membership(current_user)
      |> get_role
      |> member?
    owner && member
  end

  @doc """
  Can the user update their profile without updating the current_organization_id
  """
  def update?(%User{} = user, %Changeset{data: %User{} = current_user} = _changeset) do
    user.id == current_user.id
  end
end