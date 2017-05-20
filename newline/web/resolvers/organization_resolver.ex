defmodule Newline.OrganizationResolver do
  import Newline.BaseResolver
  import Canada, only: [can?: 2]

  alias Newline.{Organization, Repo, UserService, OrganizationService}
  
  def all(_args, %{context: %{current_user: user}}) do
    case can?(user, read Organization) do
      true -> 
        all_orgs = Repo.all(Organization) |> Repo.preload([:members])
        {:ok, all_orgs}
      false ->
        orgs = UserService.user_with_organizations(user)
        {:ok, orgs}
    end
  end
  def all(_, _), do: Newline.BaseResolver.unauthorized_error
  
  # def all(_args, %{context: %{current_user: user, admin: true}}) do
  #   all_orgs = Repo.all(Organization) |> Repo.preload([:members])
  #   {:ok, all_orgs}
  # end
  # def all(_args, %{context: %{current_user: user}}) when not is_nil(user) do
    # orgs = UserService.user_with_organizations(user)
    # {:ok, orgs}
  # end
  # def all(_, _), do: {:error, "Unauthorized"}

  def create_organization(params, %{context: %{current_user: user}}) when not is_nil(user) do
    OrganizationService.create_org(user, params)
  end
  def create_organization(_, _), do: Newline.BaseResolver.unauthorized_error

end