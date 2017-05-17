defmodule Newline.MembershipResolver do
  import Newline.BaseResolver
  import Canada, only: [can?: 2]

  alias Newline.{Organization, Repo, UserService, OrganizationService, MembershipService}

  def all(_args, %{context: %{current_user: user}}) do
    current_user = UserService.user_with_organizations(user)
    IO.inspect current_user.organizations
    {:ok, current_user.organizations}
  end
  def all(_, _), do: Newline.BaseResolver.unauthorized_error
end
