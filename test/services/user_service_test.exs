defmodule Newline.UserServiceTest do
  use Newline.ModelCase
  import Newline.Factory
  alias Newline.{UserService, User, Repo}

  test "user_signup creates a new user" do
    valid_attrs = params_for(:user)
    UserService.user_signup(valid_attrs)
    user = Repo.get_by(User, %{email: valid_attrs.email})
    assert user != nil
  end

  test "request_password_reset sets password_reset_token" do
    user = build(:user) |> Repo.insert!
    {:ok, user1} = UserService.request_password_reset(user.email)
    foundUser = Repo.get(User, user1.id)
    assert foundUser.password_reset_token != nil
  end

  test "password_reset changes user password" do
    user = build(:user) |> Repo.insert!
    UserService.request_password_reset(user.email)
    foundUser = Repo.get(User, user.id)
    {:ok, _} = UserService.password_reset(foundUser.password_reset_token, "newPassword")
    foundUser = Repo.get(User, user.id)
    assert foundUser.encrypted_password != user.encrypted_password
    assert foundUser.password_reset_token == nil
  end

end