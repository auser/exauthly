defmodule Newline.UserPolicy do
  import Newline.BasePolicy, only: [member?: 1, get_role: 1, get_membership: 2]

  alias Newline.{User}
  alias Ecto.Changeset

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