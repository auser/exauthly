defmodule Newline.OrganizationResolver do
  import Newline.BaseResolver

  alias Newline.{Organization, Repo, UserService, OrganizationService}
  
  @doc """
  Get all the organizations within the context of the user requesting

  As a site_admin, this returns all the organizations
  TODO: Pagination for long lists of organizations
  As a non-admin, this returns all organizations the user belongs to

  Example query:

      {
        organizations {
          name
        }
      }
  """
  def all(_args, %{context: %{current_user: user}}), do: OrganizationService.get_all(user)
  def all(_, _), do: Newline.BaseResolver.unauthorized_error


  @doc """
  Create an organization within the context of the user

  If the user is a site_admin, they can create the organization
  As a non-site admin, a user can create an organization

  Example mutation

      mutation create_org($name:String!) {
        create_organization(name:$name) {
          name
          slug
        }
      }
  """
  def create_organization(params, %{context: %{current_user: user}}) when not is_nil(user) do
    OrganizationService.create_org(user, params)
  end
  def create_organization(_, _), do: Newline.BaseResolver.unauthorized_error

  @doc """
  Set the user's current organization'
  """

end