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
    {:ok, resp} = UserResolver.login(%{email: user.email, password: "testing"}, :info)
    assert resp.token != nil
  end

  test "create/2 signs up a new user" do
    u = params_for(:user)
    {:ok, resp} = UserResolver.create(u, :info)
    assert resp.token != nil
  end

  describe "create user" do
    @query """
    mutation createUser($email:Email!,$name:String!,$password:String!) {
      signupWithEmailAndPassword(email:$email, name:$name, password:$password) {
        email
        verified
      }
    }
    """

    test "creates a new user with the email" do
      {:ok, %{data: res}} = @query |> run(Newline.Schema, variables: %{"email" => "bob@bob.com", "password" => "something", "name" => "Ari Lerner"})
        %{"signupWithEmailAndPassword" => %{"email" => "bob@bob.com", "verified" => false}} = res
    end

    test "cannot create a user with bad email" do
      {:ok, %{errors: [m]}} = @query |> run(Newline.Schema, variables: %{"email" => "bobcom", "password" => "something", "name" => "Ari Lerner"})
      assert Map.fetch(m, :message) == {:ok, "Argument \"email\" has invalid value $email."}
    end
  end

  describe "login_user" do
    setup [:create_user]

    @query """
    mutation login($email:Email!,$password:String!) {
      login(email:$email, password: $password) {
        token
      }
    }
    """

    test "logs a user in with email and password", %{user: user, password: password} do
      {:ok, %{data: %{"login" => %{"token" => token}}}} = @query |> run(Newline.Schema, variables: %{"email" => user.email, "password" => password})
      # {:ok, login} = Map.fetch(data, "login")
      assert token != nil
    end

    test "errors with bad email/password combo", %{user: user} do
      {:ok, result} = @query |> run(Newline.Schema, variables: %{"email" => user.email, "password" => "not_it"})
      {:ok, res} = Map.fetch(result, :errors)
      assert Map.fetch(List.first(res), :message) == {:ok, "In field \"login\": Your password does not match with the password we have on record"}
    end
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

  describe "all" do
    setup [:create_user, :create_org]
    
    @query """
    {
      users {
        email
      }
    }
    """

    test "an admin user without a current user gets all the users" do
      user1 = build(:user, %{admin: true, current_organization_id: nil}) |> Repo.insert!
      # build(:user) |> Repo.insert!

      {:ok, %{data: %{"users" => users}}} = @query |> run(Newline.Schema, context: %{current_user: user1, current_org: nil, admin: true})
      assert length(users) == 4
    end

    test "a user who is an admin of an organization can list all org members", %{org: org} do
      user1 = build(:user, %{current_organization: org}) |> Repo.insert!
      {:ok, _} = OrganizationService.insert_orgmember(user1, org, "admin")

      {:ok, %{data: %{"users" => users}}} = 
        @query |> run(Newline.Schema, context: %{current_user: user1, current_org: org, admin: false})
      
      assert length(users) == 2
    end
  end

  defp create_user(context) do
    password = "testing"
    user = build(:user) |> Repo.insert!
    context
      |> Map.put(:user, user)
      |> Map.put(:password, password)
  end

  defp create_org(%{user: user} = context) do
    {:ok, org} = OrganizationService.create_org(user, params_for(:organization))
    context
      |> Map.put(:org, org)
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