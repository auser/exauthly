defmodule Newline.OrganizationResolver do
  import Newline.BasePolicy, only: [site_admin?: 1]

  alias Newline.{Organization, Repo, UserService, OrganizationService}
  
  def all(_args, %{context: %{current_user: user}}) when not is_nil(user) do
    case site_admin?(user) do
      true -> {:ok, Repo.all(Organization)}
      _ ->
        user = UserService.user_with_organizations(user)
        orgs = %{organizations: user.organizations, current_organization: user.current_organization}
        {:ok, orgs}
    end
  end
  def all(_, _), do: {:error, "Unauthorized"}

end