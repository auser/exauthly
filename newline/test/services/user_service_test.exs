defmodule Newline.UserServiceTest do
  use Newline.ModelCase
  import Newline.Factory
  alias Newline.{UserService, OrganizationService, User, Repo, MembershipService}

  describe "user_signup" do
    setup do
      valid_attrs = params_for(:user)
      UserService.user_signup(valid_attrs)
      user = Repo.get_by(User, %{email: valid_attrs.email})
      {:ok, %{user: user}}
    end
    test "user_signup creates a new user", %{user: user} do
      assert user != nil
    end

    test "creates a default group for the user", %{user: user}  do
      assert user.current_organization_id != nil
    end

    test "joins the user in the new group", %{user: user}  do
      memberships = MembershipService.user_memberships(user)
      assert length(memberships) == 1
    end
  end

  describe "check_email_availability" do
    setup do
      user = build(:user) |> Repo.insert!
      %{email: email} = params_for(:user)
      {:ok, %{user: user, email: email}}
    end
    test "returns true when email is valid", %{email: email} do
      assert UserService.check_email_availability(email)
    end

    test "returns true when email is available", %{email: email} do
      assert UserService.check_email_availability(email)
    end

    test "returns false when email has been taken", %{user: user} do
      refute UserService.check_email_availability(user.email)
    end

    test "returns invalid when email has been taken", %{} do
      refute UserService.check_email_availability("not_email")
    end
  end

  test "user_login() with correct creds returns token" do
    user = build(:user) |> Repo.insert!
    {:ok, foundUser} = UserService.user_login(%{email: user.email, password: user.password})
    assert foundUser != nil
    assert user.email == foundUser.email
  end

  test "user with incorrect creds returns error with reason" do
    user = build(:user) |> Repo.insert!
    {:error, reason} = UserService.user_login(%{email: user.email, password: "not a password"})
    assert reason != nil
  end

  test "request_password_reset sets password_reset_token" do
    user = build(:user) |> Repo.insert!
    {:ok, true} = UserService.request_password_reset(user.email)
    foundUser = Repo.get(User, user.id)
    assert foundUser.password_reset_token != nil
  end

  test "password_reset changes user password" do
    user = build(:user) |> Repo.insert!
    UserService.request_password_reset(user.email)
    foundUser = Repo.get(User, user.id)
    {:ok, _, _, _} = UserService.reset_password(foundUser.password_reset_token, "newPassword")
    foundUser = Repo.get(User, user.id)
    assert foundUser.encrypted_password != user.encrypted_password
    assert foundUser.password_reset_token == nil
  end

  test "password change succeeds with old password" do
    user = build(:user) |> Repo.insert!
    params = %{"old_password" => "testing", "new_password" => "aNews0mthing"}
    {:ok, newUser} = UserService.change_password(user, params)
    assert User.check_user_password(newUser, "aNews0mthing")
  end

  test "password fails with bad password" do
    user = build(:user) |> Repo.insert!
    params = %{"old_password" => "testing", "new_password" => "no"}
    {:error, cs} = UserService.change_password(user, params)
    refute cs.valid?
  end

  describe "verify user" do
    test "verify belongs to a user" do
     user = build(:user, %{verify_token: "12345"}) |> Repo.insert!
     UserService.verify_user("12345")
     assert Repo.get(User, user.id).verified
    end

    test "verify token not found" do
      { :error, _ } = UserService.verify_user("12345")
    end
  end

  describe "user_with_organizations" do
    setup do
      user = build(:user) |> Repo.insert!
      %{user: user}
    end
    test "finds the user memberships", %{user: user} do
      assert UserService.user_with_organizations(user).organizations === []
    end
  end

  describe "user_memberships" do
    setup [:create_user, :create_organization]

    setup %{user: user} = context do
      owner = build(:user) |> Repo.insert!
      {:ok, org} = OrganizationService.create_org(owner, %{name: "Bob's burgers'"})
      OrganizationService.insert_orgmember(user, org)
      Map.put(context, :owner, owner)
    end

    test "Finds all memberships for a user", %{user: user} do
      memberships = UserService.user_memberships(user)

      assert length(memberships) == 2
    end
  end

  describe "set_current_organization" do
    setup [:create_user, :create_organization, :set_current_organization]

    test "sets the user current_org", %{user: user, org: org} do
      new_org = build(:organization) |> Repo.insert!
      assert user.current_organization_id == org.id
      UserService.set_current_organization(user, new_org)
      user = Repo.get!(User, user.id)
      assert user.current_organization_id == new_org.id
      refute user.current_organization_id == org.id
    end
  end

  defp create_user(context) do
    user = build(:user) |> Repo.insert!
    Map.put(context, :user, user)
  end

  defp set_current_organization(%{org: org} = context) do
    user = build(:user, %{current_organization_id: org.id}) |> Repo.insert!
    Map.put(context, :user, user)
  end

  defp create_organization(%{user: user} = context) do
    {:ok, org} = OrganizationService.create_org(user, %{name: "Fullstack.io"})
    Map.put(context, :org, org)
  end

  # defp create_membership(%{user: user, org: org} = context) do
  #   {:ok, membership} = OrganizationService.insert_orgmember(user, org)
  #   Map.put(context, :membership, membership)
  # end

end
