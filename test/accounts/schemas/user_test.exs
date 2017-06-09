defmodule Newline.UserTest do
  use Newline.SchemaCase
  import Newline.Factory
  alias Newline.{Repo}
  alias Newline.Accounts.User

  setup do
    {:ok, valid_user: build(:user)}
  end

  test "changeset with valid attributes" do
    changeset = User.user_changeset(%User{}, %{email: "ari@fullstack.io", role: "user"})
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.user_changeset(%User{}, %{})
    refute changeset.valid?
  end

  describe "social_account_changeset/2" do
    setup [:create_user]

    test "creates a valid changeset with a user_id", %{user: user} do
      user = user |> Repo.insert!
      params = params_for(:social_account)
      cs = user |> User.social_account_changeset(params)
      assert cs.valid?
    end
  end

  describe "verifying_changeset/2" do

    test("a user becomes verified after commmiting verifying changeset", %{valid_user: user1}) do
      user = user1 |> Repo.insert!
      refute user.verified
      changeset = User.verifying_changeset(user, %{verify_token: "12345"})
      assert changeset.valid?
      changeset |> Repo.update!

      assert Repo.get(User, user.id).verified
      assert Repo.get(User, user.id).verify_token == nil
    end
  end

  describe "registration_changeset/2" do

    test "sign up successful with valid params" do
      user_params = params_for(:user)
      changeset = User.registration_changeset(%User{}, user_params)
      assert changeset.valid?
    end

    test "signup with invalid email" do
      invalid_email = params_for(:user, email: "blah")
      # invalid_email = Map.put(@valid_attrs, :email, "blah")
      changeset = User.registration_changeset(%User{}, invalid_email)
      refute changeset.valid?
    end

    test "signup with a taken email", %{ valid_user: user1 } do
      # user1 = valid_user()
      user1 |> Repo.insert!
      user2 = params_for(:user, %{email: user1.email})
      changeset = User.registration_changeset(%User{}, user2)
      {:error, changeset} = Repo.insert(changeset)

      refute changeset.valid?
    end

    test "returns an error with a short password", %{} do
      short_pass = params_for(:user, password: "abc")
      changeset = User.registration_changeset(%User{}, short_pass)
      refute changeset.valid?
    end

    test "generate a password", %{ valid_user: user } do
      user |> Repo.insert!
      assert user.password != nil
    end

    test "signs up without a password", %{valid_user: user} do
      user |> Repo.insert!
      short_pass = params_for(:user, password: "")
      changeset = User.registration_changeset(%User{}, short_pass)
      refute changeset.valid?
    end
  end

  test "valid reset password changeset is valid with valid attrs", %{valid_user: user} do
    user |> Repo.insert!
    changeset =
      User.reset_password_request_changeset(%User{}, %{"email" => user.email})
    assert changeset.valid?
  end

  test "adds a password_reset_token and timestamp on reset password token", %{valid_user: user} do
    user |> Repo.insert!
    user1 = params_for(:user, %{email: user.email})
    changeset = User.reset_password_request_changeset(%User{}, user1)
    assert get_change(changeset, :password_reset_timestamp) != nil
    assert get_change(changeset, :password_reset_token) != nil
  end

  test "with a password reset changeset is valid with a new pass" do
    changeset =
      User.reset_password_changeset(%User{}, %{password: "a_newPassword"})
    assert changeset.valid?
  end

  test "password reset sets new password", %{valid_user: user} do
    user1 = user |> Repo.insert!
    user2 =
      User.reset_password_changeset(user1, %{password: "aNewPassw0rd"})
      |> Repo.update!
    assert user2.encrypted_password != user1.encrypted_password
  end

  test "change password reset", %{valid_user: user} do
    user1 = user |> Repo.insert!
    user2 =
      User.change_password_changeset(user1, %{password: "av4l1dPassw0rd"})
      |> Repo.update!
    assert user2.encrypted_password != user1.encrypted_password
  end

  test "change password fails with short password", %{valid_user: user} do
    user1 = user |> Repo.insert!
    {:error, changeset} =
      User.change_password_changeset(user1, %{password: "no"})
      |> Repo.update
    refute changeset.valid?
    assert length(changeset.errors) == 1
  end

  defp create_user(ctx) do
    ctx
    |> Map.put(:user, build(:user))
  end

end
