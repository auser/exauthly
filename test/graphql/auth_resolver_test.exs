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

    @query """
    mutation login($email:Email!,$password:String!) {
      login(email:$email, password: $password) {
        token
      }
    }
    """
    test "logs in a user with valid credentials", %{user: user} do
      {:ok, %{data: %{"login" => %{"token" => token}}}} = @query |> run(Newline.Schema, variables: %{"email" => user.email, "password" => "testing"})
      # {:ok, login} = Map.fetch(data, "login")
      assert token != nil
    end

    test "errors with bad credentials", %{user: user} do
      {:ok, result} = @query |> run(Newline.Schema, variables: %{"email" => user.email, "password" => "not_it"})
      {:ok, res} = Map.fetch(result, :errors)
      assert Map.fetch(List.first(res), :message) == {:ok, "In field \"login\": Your password does not match with the password we have on record"}
    end
  end

  describe "request_reset_password/2" do
    setup [:create_user]

    @query """
    mutation reset_password_request($email:Email!) {
      reset_password_request(email:$email)
    }
    """

    test "adds a reset token to the user", %{user: user} do
      {:ok, %{data: %{"reset_password_request" => _user}}} =
        @query |> run(Newline.Schema, variables: %{"email" => user.email})
    end

    test "errors with an email not registered" do
      {:error, false} = AuthResolver.request_reset_password(%{
        email: "not_a_user@gmail.com"
      }, %{})
    end
  end

  describe "reset_password/2" do
    setup [:create_resetting_user]

    @query """
    mutation reset_user_password($token:String!,$password:String!) {
      passwordReset(token:$token, password:$password) {
        email
        token
      }
    }
    """

    test "updates the user's password with correct token", %{user: user, token: token} do
      user = Repo.get(User, user.id)
      {:ok, %{data: %{
        "passwordReset" => %{
          "email" => email,
          "token" => token
        }
      }}} =
        @query |> run(Newline.Schema, variables: %{
          "token" => user.password_reset_token,
          "password" => "A new hope"
        })
      assert email == user.email
      assert token != nil

      {:ok, logged_in} = AuthResolver.login(%{
        email: user.email,
        password: "A new hope"
      }, %{})
      assert logged_in.token != nil
    end

    test "fails to reset password for invalid token" do
      {:ok, %{data: %{"passwordReset" => nil}, errors: [h|_]}} =
        @query |> run(Newline.Schema, variables: %{
          "token" => "Not the token",
          "password" => "Definitely ginger"
        })
      assert h.message == "In field \"passwordReset\": not_found"
    end

    test "fails to reset password for old token" do
      params = %{
        password: nil,
        password_reset_token: "AnOldToken",
        password_reset_timestamp: Timex.shift(Timex.now(), months: -3)
      }
      build(:user, params) |> Repo.insert!

      {:ok, %{data: %{"passwordReset" => nil}, errors: [h|_]}} =
        @query |> run(Newline.Schema, variables: %{
          "token" => "AnOldToken",
          "password" => "Definitely ginger"
        })
      assert h.message == "In field \"passwordReset\": not_found"
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
