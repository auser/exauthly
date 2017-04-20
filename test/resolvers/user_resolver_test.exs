defmodule Newline.UserResolverTest do
  use Newline.ModelCase
  import Newline.Factory
  alias Newline.{UserResolver}

  setup do
    user = insert(:user)
    {
      :ok, 
      current_user: user,
      context: %{context: %{ current_user: user }},
      valid_org: insert(:organization)
    }
  end

  test "all/2 returns undefined without user" do
    assert UserResolver.all(:something, %{}) == {:error, "Unauthorized"}
  end

  test "all/2 returns all the users if the user is an admin" do
    insert(:user)
    context = %{context: %{current_user: insert(:user, admin: true)}}
    {:ok, users} = UserResolver.all(:type, context)
    assert length(users) == 4
  end

  test "all/2 returns only the current user", %{context: context, current_user: current_user} do
    {:ok, user} = UserResolver.all(:type, context)
    assert user.id == current_user.id
  end

  test "login/2 returns false with bad credentials" do
    {:error, "bad_credentials"} = UserResolver.login(%{}, :info)
  end

  test "login/2 returns okay with valid credentials", %{current_user: user} do
    {:ok, resp} = UserResolver.login(%{email: user.email, password: "Something"}, :info)
    assert resp.token != nil
  end

  test "create/2 signs up a new user" do
    u = params_for(:user)
    {:ok, resp} = UserResolver.create(u, :info)
    assert resp.token != nil
  end

end