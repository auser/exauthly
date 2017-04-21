defmodule Newline.V1.SessionControllerTest do
  use Newline.ConnCase

  setup do
    conn = 
      %{build_conn() | host: ""}
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")
    
    {:ok, conn: conn}
  end

  defp create_payload(email, password) do
    %{"email" => email, "password" => password}
  end

  describe "create" do
    test "login returns jwt and user_id with valid creds", %{conn: conn} do
      user = build(:user, %{password: "password"}) |> set_password("password") |> insert
      conn = post conn, "/api/v1/login", create_payload(user.email, user.password)

      user_id = user.id
      response = json_response(conn, 201)
      assert response["token"]
      assert response["user_id"] == user_id
    end

    test "login returns error when incorrect password", %{conn: conn} do
      user = build(:user, %{password: "pass"}) |> set_password("pass") |> insert
      conn = post conn, "/api/v1/login", create_payload(user.email, "not the password")

      resp = json_response(conn, 401)
      [err|_] = resp["errors"]
      assert err["id"] == "unauthorized"
      refute resp["token"]
      refute resp["user_id"]
    end
  end

end