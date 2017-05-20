defmodule Newline.UserResolverTest do
  use Newline.ModelCase
  use Newline.GqlCase
  import Newline.AssertResult
  import Newline.Factory
  alias Newline.{UserResolver, OrganizationService, User}

  setup [:create_admin_user]

  test "all/2 returns undefined without user" do
    assert UserResolver.all(:something, %{}) == {:error, "Unauthorized"}
  end

  test "all/2 returns all the users if the user is an admin of group", %{current_org: current_org} = context do
    context = %{context: %{context | admin: false, role: "owner"}}
    another_user = build(:user, %{admin: false}) |> Repo.insert!
    {:ok, _} = OrganizationService.insert_orgmember(another_user, current_org)

    {:ok, users} = UserResolver.all(:type, context)
    assert length(users) == 2
  end

  test "all/2 returns only the current user", context do
    context = %{context: %{ context | role: nil }}
    assert {:error, _} = UserResolver.all(:type, context)
  end

  test "login/2 returns false with bad credentials" do
    {:error, "bad_credentials"} = UserResolver.login(%{}, :info)
  end

  test "login/2 returns okay with valid credentials", %{current_user: user} do
    {:ok, resp} = UserResolver.login(%{email: user.email, password: "Something"}, :info)
    assert resp.token != nil
  end

  test "create/2 signs up a new user" do
    u = params_for(:user)
    {:ok, resp} = UserResolver.create(u, :info)
    assert resp.token != nil
  end

  describe "verify_user" do
    setup [:create_admin_user, :save_user_with_token]

    test "successfully verifies a new user", %{saved_user: user} do
      query = """
        mutation verify($verifyToken:String!){
          verifyUser(verifyToken:$verifyToken){id verified}
        }
        """
      assert_result {:ok, %{data: %{"verifyUser" => %{"id" => "#{user.id}", "verified" => true}}}}, 
        query |> run(Newline.Schema, variables: %{"verifyToken" => user.verify_token})
    end

    test "does not verify a user without a valid token" do
      query = """
      mutation verify($verifyToken:String!){
        verifyUser(verifyToken:$verifyToken){id}
      }
      """
      assert_result {:ok, %{errors:
        [%{message: "In field \"verifyUser\": not_found"}], data: %{"verifyUser" => nil} }},
        query |> run(Newline.Schema, variables: %{"verifyToken" => "blah"})
    end
  end

  defp create_admin_user(context) do
    user = build(:user, %{admin: true}) |> Repo.insert!
    {:ok, org} = OrganizationService.create_org(user, params_for(:organization))
    user = Repo.get!(User, user.id) ## Reload
    context
      |> Map.put(:admin, false)
      |> Map.put(:current_user, user)
      |> Map.put(:current_org, org)
      |> Map.put(:role, "owner")
  end

  defp save_user_with_token(context) do
    user = build(:user, %{verify_token: "12345"}) |> Repo.insert!
    context
    |> Map.put(:verify_token, "12345")
    |> Map.put(:saved_user, user)
  end

end