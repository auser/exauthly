defmodule Newline.Resolvers.OrganizationResolver do
  import Newline.Resolvers.BaseResolver
  # import Newline.BasePolicy

  alias Newline.Accounts.OrganizationService

  @doc """
  Get organization details
  """
  def get_org_by_slug(%{slug: slug}, %{context: %{current_user: _}}) do
    OrganizationService.get_org_by_slug(slug)
  end

  def get_org_by_slug(_, _), do: unauthorized_error()

  @doc """
  List user organizations
  """
  def list_user_orgs(_params, %{context: %{current_user: user}}) do
    OrganizationService.list_user_orgs(user)
  end

  @doc """
  Creates an Organization

  ## Examples

      iex> create_organization(%{slug: "name-thing", name: "Name thing"})
  """
  def create_organization(params, %{context: %{current_user: _}}) do
    OrganizationService.create_organization(params)
  end

end
