defmodule Newline.Policies.UserPolicy do
  import Newline.Policies.BasePolicy, only: [
    member?: 1, get_role: 1,
    get_membership: 2, at_least_admin?: 2,
    at_least_manager?: 2, site_admin?: 1
  ]

  alias Newline.Accounts.{User, Organization}
  alias Ecto.Changeset

  defimpl Canada.Can, for: User do
    @admin_actions  [:admin]
    @list_actions   [:list]
    @read_actions   [:read]
    @write_actions  [:update, :create]
    # @destroy_actions [:destroy]

    @doc """
    User permissions

    A user can run _any_ action on themselves. (TODO: decide if they can destroy things on themselves)
    A user can read their own organizations
    An organization owner/admin user can write anything on the organization
    A user can read their own organizations
    """
    # User can do all the actions they want on themselves
    def can?(%User{id: user_id}, action, %User{id: user_id}) when action in @read_actions or action in @write_actions , do: true
    # User can do all the admin actions if they are an admin
    def can?(%User{} = user, action, _) when action in @admin_actions, do: site_admin?(user)
    # User can read their own organizations
    def can?(%User{} = user, action, %Organization{} = org) when action in @read_actions or action in @list_actions, do: at_least_manager?(user, org)
    # An admin user can write all of their memberships
    def can?(%User{} = user, action, %Organization{} = org) when action in @write_actions, do: at_least_admin?(user, org)
    # A user can read a list of their own organizations
    def can?(%User{} = _user, action, Organization) when action in @list_actions or action in @read_actions, do: true
    # A user can create any number of organizations (TODO: Is this true? Verified users?)
    def can?(%User{} = _user, action, Organization) when action in @write_actions, do: true
    # An admin can do anything
    def can?(%User{admin: admin, current_organization_id: nil} = _user, _, _), do: admin

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
