defmodule Newline.UserResolverTest do
  use Newline.ModelCase
  use Newline.GqlCase
  import Newline.AssertResult
  import Newline.Factory
  # import Newline.BasePolicy, only: [get_membership: 2]
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

  test "create/2 signs up a new user" do
    u = params_for(:user)
    {:ok, resp} = UserResolver.create(u, :info)
    assert resp.token != nil
  end

  describe "all users" do
    setup [:create_user, :create_org]

    @query """
    {
      users {
        email
        admin
        role
      }
    }
    """

    test "finds all the users for the platform with an admin user", %{current_user: user} do
      {:ok, %{data: %{"users" => users}}} = @query |> run(Newline.Schema, context: %{current_user: user, admin: true, current_org: nil})
      assert length(users) == 3
      assert length(Enum.filter(users, fn (x) -> x["admin"] end)) == 2
    end

    test "finds all the users for a particular organization when user is an admin of the group", %{current_user: user, current_org: org} do
      # user1 = build(:user) |> Repo.insert!
      # OrganizationService.insert_orgmember(user1, org)
      # OrganizationService.update_orgrole(user1, org, "admin")
      {:ok, _} = OrganizationService.update_user_current_org(user, org)

      {:ok, %{data: %{"users" => users}}} = @query |> run(Newline.Schema, context: %{current_user: user, current_org: org})
      assert length(users) == 1
    end

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

  describe "verify_user" do
    setup [:save_user_with_token]

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

    test "the owner of an organization can list all org members", %{user: user, org: org} do
      {:ok, _} = OrganizationService.update_orgrole(user, org, "owner")
      {:ok, %{data: %{"users" => [u|_] = users}}} = @query |> run(Newline.Schema, context: %{current_user: user, current_org: org})
      assert length(users) == 1
      assert u["email"] == user.email
    end

    test "a manager of an organization can list all org members", %{user: user, org: org} do
      {:ok, _} = OrganizationService.update_orgrole(user, org, "manager")
      {:ok, %{data: %{"users" => [u|_] = users}}} = @query |> run(Newline.Schema, context: %{current_user: user, current_org: org})
      assert length(users) == 1
      assert u["email"] == user.email
    end

    test "a member of an organization cannot list users", %{user: user, org: org} do
      {:ok, _} = OrganizationService.update_orgrole(user, org, "member")
      {:ok, %{data: %{"users" => nil}, errors: [errors|_]}} = @query |> run(Newline.Schema, context: %{current_user: user, current_org: org})
      assert errors[:message] == "In field \"users\": Unauthorized"
    end
  end

  describe "check_email_availability" do
    setup [:create_user]
    @query """
    mutation checkEmailAvailable($email:Email!) {
      checkEmailAvailability(email:$email)
    }
    """

    test "it tests if an email is available" do
      {:ok, %{data: %{"checkEmailAvailability" => true}}} = @query |> run(Newline.Schema, variables: %{"email" => "user@222.com"})
    end

    test "it fails if an email is unavailable", %{user: user} do
      {:ok, %{data: %{"checkEmailAvailability" => false}}} = @query |> run(Newline.Schema, variables: %{"email" => user.email})
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
    user = build(:user, %{admin: true, role: "admin"}) |> Repo.insert!
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