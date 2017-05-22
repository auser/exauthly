defmodule Newline.AuthResolverTest do
  use Newline.ModelCase
  use Newline.GqlCase
  # import Newline.AssertResult
  import Newline.Factory
  alias Newline.{Schema, UserService, User}

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
  describe "request_reset_password" do
    setup [:create_user]

    @query """
    mutation reset_password_request($email:Email!) {
      reset_password_request(email:$email)
    }
    """

    test "creates a password reset token on the user", %{user: user} do
      {:ok, %{data: %{"reset_password_request" => true}}} =
        @query |> run(Schema, variables: %{"email" => user.email})
    end

    test "fails when the user does not belong to a user" do
      {:ok, %{data: %{"reset_password_request" => nil}, errors: [h|_]}} =
        @query |> run(Schema, variables: %{"email" => "not-an-email@okright.com"})
      
      assert h.message == "In field \"reset_password_request\": false"
    end
  end

  describe "reset_password" do
    setup [:create_user, :request_password_reset]

    @query """
    mutation reset_user_password($token:String!,$password:String!) {
      passwordReset(token:$token, password:$password) {
        email
        token
      }
    }
    """

    test "resets the user password", %{user: user} do
      user = Repo.get(User, user.id)
      {:ok, %{data: %{"passwordReset" => %{"email" => email, "token" => token}}}} =
        @query |> run(Schema, variables: %{"token" => user.password_reset_token, "password" => "another"})

      assert email == user.email
      assert token != nil
    end
  end

  defp create_user(context) do
    password = "testing"
    user = build(:user) |> Repo.insert!
    context
      |> Map.put(:user, user)
      |> Map.put(:password, password)
  end

  defp request_password_reset(%{user: user} = context) do
    UserService.request_password_reset(user.email)
    context
  end

end