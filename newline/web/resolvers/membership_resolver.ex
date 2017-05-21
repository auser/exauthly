defmodule Newline.MembershipResolver do
  import Newline.BaseResolver
  # import Canada, only: [can?: 2]

  alias Newline.MembershipService

  @doc """
  Get all user memberships

  This returns back a list of memberships of which the user belongs

  Example resolver

      {
        memberships {
          role
          organization {
            name
          }
        }
      }
  """
  def user_memberships(_args, %{context: %{current_user: user}}) do
    {:ok, MembershipService.user_memberships(user)}
  end
  def user_memberships(_, _), do: Newline.BaseResolver.unauthorized_error
end
