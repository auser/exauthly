defmodule Newline.AuthResolverTest do
  use Newline.DataCase
  use Newline.GqlCase
  import Newline.Factory
  alias Newline.Repo
  # import Newline.BasePolicy, only: [get_membership: 2]
  alias Newline.Resolvers.AuthResolver
  alias Newline.Accounts.User

  describe "login/2" do
    setup [:create_user]

    test "logs in a user with valid credentials", %{user: user} do
      {:ok, logged_in} = AuthResolver.login(%{email: user.email, password: "testing"}, %{})
      assert logged_in.token != nil
      assert logged_in.email == user.email
    end

    test "errors with bad credentials", %{user: user} do
      {:error, reason} = AuthResolver.login(%{
        email: user.email,
        password: "Not it!"
      }, %{})
      assert reason == :wrong_credentials
    end
  end

  describe "request_reset_password/2" do
    setup [:create_user]

    test "adds a reset token to the user", %{user: user} do
      {:ok, _} = AuthResolver.request_reset_password(%{
        email: user.email
      }, %{})
      user = Repo.get(User, user.id)
      assert user.password_reset_token != nil
      assert user.password_reset_timestamp != nil
    end

    test "errors with an email not registered" do
      {:error, false} = AuthResolver.request_reset_password(%{
        email: "not_a_user@gmail.com"
      }, %{})
    end
  end

  describe "reset_password/2" do
    setup [:create_resetting_user]

    test "updates the user's password with correct token", %{user: user, token: token} do
      {:ok, resp} = AuthResolver.reset_password(%{
        password: "A new hope",
        token: token
      }, %{})
      assert resp.token != nil

      {:ok, logged_in} = AuthResolver.login(%{
        email: user.email,
        password: "A new hope"
      }, %{})
      assert logged_in.token != nil
    end

    test "fails to reset password for invalid token" do
      {:error, :not_found} = AuthResolver.reset_password(%{
        password: "Definitely Ginger",
        token: "AnotherCrazyToken"
      }, %{})
    end

    test "fails to reset password for old token" do
      params = %{
        password: nil,
        password_reset_token: "AnOldToken",
        password_reset_timestamp: Timex.shift(Timex.now(), months: -3)
      }
      build(:user, params) |> Repo.insert!

      {:error, :not_found} = AuthResolver.reset_password(%{
        password: "Definitely Ginger",
        token: "AnOldToken"
      }, %{})
    end

  end

  defp create_user(context) do
    user = build(:user, %{password: nil}) |> Repo.insert!
    context
    |> Map.put(:user, user)
  end

  defp create_resetting_user(context) do
    params = %{
      password: nil,
      password_reset_token: "SomeToken",
      password_reset_timestamp: Timex.beginning_of_day(Timex.now())
    }
    user = build(:user, params) |> Repo.insert!
    context
    |> Map.put(:user, user)
    |> Map.put(:token, "SomeToken")
  end

end
