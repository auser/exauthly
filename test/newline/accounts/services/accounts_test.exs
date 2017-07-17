defmodule Newline.AccountsTest do
  use Newline.DataCase

  import Newline.Factory
  alias Newline.Accounts
  alias Newline.Accounts.{User, OrganizationService}

  setup do
    {:ok, valid_user: build(:user)}
  end

  describe "registration" do
    test "signup with invalid email" do
      invalid_email = params_for(:user, email: "blah")
      # invalid_email = Map.put(@valid_attrs, :email, "blah")
      {:error, changeset} = Accounts.create_user(invalid_email)
      refute changeset.valid?
    end

    test "signup with a taken email", %{valid_user: user1} do
      # user1 = valid_user()
      user1 |> Repo.insert!
      user2 = params_for(:user, %{email: user1.email})
      {:error, changeset} = Accounts.create_user(user2)
      # {:error, changeset} = Repo.insert(changeset)

      refute changeset.valid?
    end

    test "returns an error with a short password", %{} do
      short_pass = params_for(:user, password: "abc")
      {:error, changeset} = Accounts.create_user(short_pass)
      refute changeset.valid?
    end

    test "generate a password", %{valid_user: user} do
      user |> Repo.insert!
      assert user.password != nil
    end

    test "signs up without a password", %{valid_user: user} do
      user |> Repo.insert!
      short_pass = params_for(:user, password: "")
      {:error, _changeset} = Accounts.create_user(short_pass)
    end

    test "creates an account for the user within an org" do
      user = params_for(:user, %{})
      {:ok, user} = Accounts.create_user(user)
      # org = Organization
            # Repo.preload(:members) |> Repo.get(user.id)
      orgs = Repo.preload(user, :organizations)
      assert length(orgs.organizations) == 1
      [h|_] = orgs.organization_memberships
      assert h.role == "owner"
    end
  end

  describe "update_user" do
    setup [:create_user]

    test "can update the user's name", %{user: user} do
      {:ok, updated} = Accounts.update_user(user, %{"name" => "Ari D. Lerner"})
      assert updated.name != user.name
    end

    test "can update the user's email", %{user: user} do
      {:ok, updated} = Accounts.update_user(user, %{"email" => "ari+2@fullstack.io"})
      assert updated.email == "ari+2@fullstack.io"
    end
  end

  describe "request reset password" do
    setup [:create_user]

    test "sets the password_reset_token", %{user: user} do
      {:ok, _} = Accounts.request_user_password_reset(user.email)
      found_user = Repo.get_by(User, %{email: user.email})
      assert found_user.password_reset_token != nil
    end

    test "set the password_reset_timestamp", %{user: user} do
      {:ok, _} = Accounts.request_user_password_reset(user.email)
      found_user = Repo.get_by(User, %{email: user.email})
      assert found_user.password_reset_timestamp != nil
    end

    test "can be found by password_reset_token", %{user: user} do
      {:ok, updated_user} = Accounts.request_user_password_reset(user.email)
      found_user = Repo.get_by(User, %{
        password_reset_token: updated_user.password_reset_token
      })
      assert found_user.id == user.id
    end

    test "returns error with email not registered" do
      {:error, _} = Accounts.request_user_password_reset("not@email.com")
    end
  end

  describe "authenticate" do
    setup do
      import Comeonin.Bcrypt, only: [hashpwsalt: 1]
      pass = "abc123"
      encrypted = hashpwsalt(pass)
      user = build(:user, %{
        password: pass,
        encrypted_password: encrypted,
      }) |> Repo.insert!
      {:ok, %{user: user, pass: pass}}
    end

    test "it validates the user password", %{user: user, pass: pass} do
      {:ok, _res} = Accounts.authenticate(%{"email" => user.email, "password" => pass})
    end
  end

  describe "user_login" do
    setup [:create_user]

    test "with valid creds returns user with token", %{user: user} do
      valid_creds = %{
        "email" => user.email,
        "password" => "testing"
      }
      {:ok, logged_in} = Accounts.user_login(valid_creds)
      assert logged_in.id == user.id
    end

    test "with invalid creds returns error" do
      invalid_creds = %{"email" => "no@me.com", "password" => "abc123"}
      {:error, reason} = Accounts.user_login(invalid_creds)
      assert reason == "Your password does not match with the password we have on record"
    end
  end

  describe "social_authentication/1" do
    setup [:create_social_account_user]

    test "logs in user with valid token", %{social_account: account} do
      {:ok, _} = Accounts.social_authentication(%{provider: account.provider, uid: account.uid})
    end
  end

  describe "sign_in_user(:api)" do
    setup [:create_user]

    @tag :pending
    test "adds the user to the connection" do
    end
  end

  describe "sign_in_user(:token)" do
    setup [:create_user]

    test "Generates a valid JWT token", %{user: user} do
      {:ok, jwt, _claims} = Accounts.sign_in_user(:token, user)
      {:ok, res} = Guardian.decode_and_verify(jwt)
      {:ok, id} = Map.fetch(res, "aud")
      assert id == "User:#{user.id}"
    end
  end

  describe "check_email_availability" do
    setup [:create_user]

    test "shows an email is not available when taken", %{user: user} do
      refute Accounts.check_email_availability(user.email)
    end

    test "shows an email is available when not taken" do
      assert Accounts.check_email_availability("solid@email.com")
    end
  end

  describe "user_by_password_token" do
    setup [:create_user]

    test "finds the user by their reset token" do
      user = build(:user, %{
        password_reset_token: "token123",
        password_reset_timestamp: Timex.now
      }) |> Repo.insert!

      assert user.id == Accounts.user_by_password_token("token123").id
    end
  end

  describe "associate_social_account/3" do
    setup [:create_user]

    test "associates github to the social account and user", %{user: user} do
      sa = params_for(:social_account)
      |> Enum.reduce(%{}, fn ({key, val}, acc) -> Map.put(acc, to_string(key), val) end)

      {:ok, sa} = Accounts.associate_social_account("github", user, sa)
      assert sa.user_id == user.id
      user = user |> Repo.preload(:social_accounts)
      connected = Enum.map(user.social_accounts, fn(x) -> x.provider end)
      assert connected == ["github"]
    end
  end

  describe "disassociate_social_account/2" do
    setup [:create_user]

    test "deletes the social account", %{user: user} do
      sa = params_for(:social_account)
      |> Enum.reduce(%{}, fn ({key, val}, acc) -> Map.put(acc, to_string(key), val) end)
      {:ok, sa} = Accounts.associate_social_account("github", user, sa)

      Accounts.disassociate_social_account("github", user, sa.id)
      user = Repo.get(User, user.id)
      user = user |> Repo.preload(:social_accounts)
      assert user.social_accounts == []
    end
  end

  describe "user_link_and_signup/3" do
    setup [:create_user]
    test "creates the user and gives the association if there isn't one already" do
      Accounts.user_link_and_signup("gumroad", nil, %{
        "email" => "foo@bar.com",
        "uid" => "GumroadUserId",
        "provider" => "gumroad"
      })
      user = Repo.get_by!(User, email: "foo@bar.com")
      assert user
      user = Repo.preload(user, :social_accounts)
      assert length(user.social_accounts) == 1
    end

    test "adds a social asscociation if there is a a user", %{user: user} do
      Accounts.user_link_and_signup("gumroad", user.id, %{
        "email" => user.email,
        "uid" => "GumroadUserId2",
        "provider" => "gumroad"
      })
      user = Repo.get_by!(User, email: user.email)
      assert user
      user = Repo.preload(user, :social_accounts)
      assert length(user.social_accounts) == 1
    end
  end

  describe "get_social_account/2" do
    setup [:create_user]

    test "can get a social account by id" do
      sa = build(:social_account, %{
        provider: "gumroad",
      }) |> Repo.insert!
      user = sa.user
      {:ok, sa} = Accounts.get_social_account(user, :gumroad)
      assert sa != nil
      assert sa.user_id == user.id
    end
  end

  describe "set_current_organization/2" do
    setup [:create_user, :create_org]

    test "updates the user's current org", %{org: org, user: user} do
      {:ok, _membership} = OrganizationService.join_org(user, org)

      {:ok, _} = Accounts.set_current_organization(user, org)
      user = Repo.get(User, user.id)
      # current_org = Repo.preload(user, :current_organization)
      # IO.inspect current_org
      assert user.current_organization_id == org.id
    end
  end

  defp create_user(context) do
    user = build(:user) |> Repo.insert!
    context
    |> Map.put(:user, user)
  end

  defp create_social_account_user(context) do
    account = build(:social_account) |> Repo.insert!
    context
    |> Map.put(:social_account, account)
    |> Map.put(:user, account.user)
  end

  defp create_org(context) do
    org = build(:organization) |> Repo.insert!
    context
    |> Map.put(:org, org)
  end
end
