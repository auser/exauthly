defmodule Newline.MembershipService do
  use Newline.Web, :service

  alias Newline.{User, UserService, OrganizationMembership, Organization}

  @doc """
  Get the user membership for a specific organization
  """
  def user_membership_for(%User{id: user_id}, %Organization{id: org_id}) do
    do_get_membership(org_id, user_id)
  end
  def user_membership_for(%User{id: user_id}, org_id) when is_binary(org_id), do: do_get_membership(org_id, user_id)
  def user_membership_for(%User{}, nil), do: nil
  def user_membership_for(_, _), do: nil

  defp do_get_membership(organization_id, user_id) do
    OrganizationMembership
    |> where([m], m.member_id == ^user_id and m.organization_id == ^organization_id)
    |> Repo.one
  end

  @doc """
  Get user memberships
  """
  def user_memberships(%User{id: user_id}), do: UserService.user_memberships(user_id)

end