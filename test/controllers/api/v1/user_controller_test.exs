defmodule Newline.V1.UserControllerTest do
  use Newline.ConnCase
  alias Newline.{Repo, User, Email}
  use Bamboo.Test

  @valid_attrs %{
    email: "test@fullstack.io"
  }

  @invalid_attrs %{
    email: "not_an_email"
  }

  describe "signup" do
    test "POST /api/v1/signup with valid data", %{conn: conn} do
      attrs = Map.put(@valid_attrs, :password, "passw0rd")

      conn = post conn, "/api/v1/signup", attrs

      assert conn |> json_response(201)
      new_user = Repo.get_by!(User, email: "test@fullstack.io")
      assert_delivered_email Email.welcome_email(new_user)
    end

    test "POST /api/v1/signup when email already exists", %{conn: conn} do
      user = insert(:user)
      conn = post conn, "/api/v1/signup", %{email: user.email, password: "passw0rd"}
      assert conn |> json_response(422)
    end

    test "POST /api/v1/signup with invalid attrs (without a password)", %{conn: conn} do
      conn = post conn, "/api/v1/signup", @invalid_attrs
      assert conn |> json_response(422)
    end

    test "POST /api/v1/signup with invalid attrs (bad email)", %{conn: conn} do
      conn = post conn, "/api/v1/signup", Map.put(@invalid_attrs, :password, "passw0rd")
      assert conn |> json_response(422)
    end

    test "POST /api/v1/signup with bad password", %{conn: conn} do
      conn = post conn, "/api/v1/signup", Map.put(@invalid_attrs, :password, "pass")
      assert conn |> json_response(422)
    end
  end

  describe "request_password_reset" do
    test "POST /api/v1/password/request sends reset email and sets token", %{conn: conn} do
      user = insert(:user, email: "forgetful@fullstack.io")
      conn = post conn, "/api/v1/password/request", %{email: user.email}

      assert conn |> response(200)

      u = Repo.get_by!(User, email: user.email)
      assert u.password_reset_token != nil
      assert u.password_reset_timestamp != nil
      assert_delivered_email Email.password_reset_request_email(u)
    end

    test "POST/api/v1/password/request with unknown user", %{conn: conn} do
      conn = post conn, "/api/v1/password/request", %{email: "unknown@fullstack.io"}
      resp = json_response(conn, 404)
      [err|_] = resp["errors"]
      assert err == "user does not exist"
    end

    test "POST /api/v1/password/request without an email", %{conn: conn} do
      conn = post conn, "/api/v1/password/request"
      conn |> response(422)
    end
  end

  describe "password_reset" do
    test "POST /api/v1/password/reset with existing token and new password succeeds", %{conn: conn} do
      user = insert(:user, email: "forgetful@fullstack.io")
      Newline.UserService.request_password_reset(user.email)
      user = Repo.get_by!(User, email: user.email)

      conn = post conn, "/api/v1/password/reset", %{token: user.password_reset_token, password: "n3wpassw0rd"}

      assert conn |> response(200)
      
      new_user = Repo.get_by!(User, email: user.email)
      assert User.check_user_password(new_user, "n3wpassw0rd")
    end
  end

end