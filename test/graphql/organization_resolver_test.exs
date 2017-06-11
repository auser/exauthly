defmodule Newline.OrganizationResolverTest do
  use Newline.DataCase
  use Newline.GqlCase
  # import Newline.AssertResult
  import Newline.Factory
  # import Newline.BasePolicy, only: [get_membership: 2]
  alias Newline.Resolvers.OrganizationResolver
  # alias Newline.Accounts
  # alias Newline.Accounts.User

  describe "list_user_orgs/2" do
  end

  defp create_user(context) do
    context
    |> Map.put(:user, build(:user))
  end
end
