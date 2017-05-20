defmodule Newline.UserPolicy do
  import Newline.BasePolicy, only: [member?: 2, member?: 1, get_role: 1, get_membership: 2, at_least_admin?: 2, at_least_manager?: 2]

  alias Newline.{User, Organization}
  alias Ecto.Changeset

  defimpl Canada.Can, for: User do
    @admin_actions  [:admin]
    @list_actions   [:list]
    @read_actions   [:read]
    @write_actions  [:update, :create, :destroy]

    # User can do all the actions they want on themselves
    def can?(%User{id: user_id}, _action, %User{id: user_id}), do: true
    # User can read their own organizations
    def can?(%User{} = user, action, %Organization{} = org) when action in @read_actions, do: at_least_manager?(user, org)
    # An admin user can read all of their members
    def can?(%User{} = user, action, %Organization{} = org) when action in @write_actions, do: at_least_admin?(user, org)
    # An admin can do anything
    def can?(%User{admin: admin, current_organization_id: nil} = user, _, _), do: admin

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