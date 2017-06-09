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

end
