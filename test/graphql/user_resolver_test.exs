defmodule Newline.UserResolverTest do
  use Newline.DataCase
  use Newline.GqlCase
  # import Newline.AssertResult
  import Newline.Factory
  # import Newline.BasePolicy, only: [get_membership: 2]
  alias Newline.Resolvers.UserResolver
  alias Newline.Accounts
  # alias Newline.Accounts.User

  describe "list_users/2" do
    setup [:create_admin_user]
    test "returns unauthorized without user" do
      assert UserResolver.list_users(:something, %{}) == {:error, "Unauthorized"}
    end

    test "returns all users with admin user", %{user: user} do
      ctx = %{context: %{current_user: user}}
      assert UserResolver.list_users(:something, ctx) == [user]
    end
  end

  describe "check_email_availability/2" do
    setup [:create_user]

    test "returns false for an email already registered", %{user: user} do
      {:ok, false} = UserResolver.check_email_availability(%{email: user.email}, %{})
    end

    test "returns true for an unused email" do
      {:ok, true} = UserResolver.check_email_availability(%{email: "not@email.com"}, %{})
    end
  end

  describe "create_user/2" do
    test "signup with valid parameters succeeds" do
      user = build(:user)
      params = %{
        email: user.email,
        password: "testing",
        name: "Ari Lerner"
      }
      {:ok, created_user} = UserResolver.create_user(params, %{})
      assert user.email == created_user.email

      params = %{
        email: user.email, password: "testing"
      }
      {:ok, found_user} = Accounts.user_login(params)
      assert found_user.id == created_user.id
    end

    test "signup fails with too short password" do
      user = build(:user)
      params = %{
        email: user.email,
        password: "a",
        name: "Ari Lerner"
      }
      {:error, cs} = UserResolver.create_user(params, %{})
      refute cs.valid?
      assert cs.errors[:password]
      {_msg, validation} = cs.errors[:password]
      assert validation[:validation] == :length
    end

    test "signup fails without an email" do
      params = %{
        email: "",
        password: "testing"
      }
      {:error, cs} = UserResolver.create_user(params, %{})
      refute cs.valid?
      {_msg, validation} = cs.errors[:email]
      assert validation[:validation] == :required
    end

    test "signup fails with invalid email" do
      params = %{
        email: "not_an_email",
        password: "testing"
      }
      {:error, cs} = UserResolver.create_user(params, %{})
      refute cs.valid?
      {_msg, validation} = cs.errors[:email]
      assert validation[:validation] == :format
    end
  end

  describe "me/2" do
    setup [:create_user]

    test "me returns the calling user", %{user: user} do
      ctx = %{context: %{current_user: user}}
      {:ok, u} = UserResolver.me(%{}, ctx)
      assert u.id == user.id
    end

    test "fails without a currently logged in user" do
      {:error, err} = UserResolver.me(%{}, %{})
      assert err == "User not logged in"
    end
  end

  describe "verify_user/2" do
    setup [:create_user]

    test "verifies a current user's email", %{user: user} do
      token = user.verify_token
      {:ok, u} = UserResolver.verify_user(%{verify_token: token}, %{})
      assert u.verified
      assert u.verify_token == nil
    end

    test "errors with invalid verify token" do
      {:error, :not_found} = UserResolver.verify_user(%{verify_token: "blah"}, %{})
    end

    test "errors without a verify_token" do
      {:error, :not_found} = UserResolver.verify_user(%{verify_token: ""}, %{})
    end

    test "errors without params" do
      {:error, :invalid} = UserResolver.verify_user(%{}, %{})
    end
  end

  describe "update_user/2" do
    setup [:create_user]

    test "can update a user's name", %{user: user} do
      ctx = %{context: %{current_user: user}}
      {:ok, user} = UserResolver.update_user(%{name: "Pete Nobody"}, ctx)
      user = Repo.get(Newline.Accounts.User, user.id)
      assert user.name == "Pete Nobody"
    end

    test "can update a user's email with valid email", %{user: user} do
      ctx = %{context: %{current_user: user}}
      {:ok, user} = UserResolver.update_user(%{email: "peter@nobody.com"}, ctx)
      user = Repo.get(Newline.Accounts.User, user.id)
      assert user.email == "peter@nobody.com"
    end

    test "fails to update a user's email with invalid email", %{user: user} do
      ctx = %{context: %{current_user: user}}
      {:error, _cs} = UserResolver.update_user(%{email: "peternobody.com"}, ctx)
      user = Repo.get(Newline.Accounts.User, user.id)
      refute user.email == "peternobody.com"
    end

    test "can update a user's username", %{user: user} do
      ctx = %{context: %{current_user: user}}
      {:ok, user} = UserResolver.update_user(%{username: "pnobody"}, ctx)
      user = Repo.get(Newline.Accounts.User, user.id)
      assert user.username == "pnobody"
    end
  end

  defp create_user(context) do
    user = build(:user, %{password: nil}) |> Repo.insert!
    context
    |> Map.put(:user, user)
  end

  defp create_admin_user(context) do
    user = build(:user, %{admin: true, password: nil}) |> Repo.insert!
    context
    |> Map.put(:user, user)
  end

end
