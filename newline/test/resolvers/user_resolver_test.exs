defmodule Newline.UserResolverTest do
  use Newline.ModelCase
  import Newline.Factory
  alias Newline.{UserResolver, OrganizationService, User}

  setup [:create_admin_user]

  test "all/2 returns undefined without user" do
    assert UserResolver.all(:something, %{}) == {:error, "Unauthorized"}
  end

  test "all/2 returns all the users if the user is an admin of group", %{current_org: current_org} = context do
    context = %{context: %{context | admin: false, role: "owner"}}
    another_user = build(:user, %{admin: false}) |> Repo.insert!
    {:ok, _} = OrganizationService.insert_orgmember(another_user, current_org)

    {:ok, users} = UserResolver.all(:type, context)
    assert length(users) == 2
  end

  test "all/2 returns only the current user", context do
    context = %{context: %{ context | role: nil }}
    assert {:error, _} = UserResolver.all(:type, context)
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

  defp create_admin_user(context) do
    user = build(:user, %{admin: true}) |> Repo.insert!
    {:ok, org} = OrganizationService.create_org(user, %{name: "Fullstack.io"})
    user = Repo.get!(User, user.id) ## Reload
    context
      |> Map.put(:admin, false)
      |> Map.put(:current_user, user)
      |> Map.put(:current_org, org)
      |> Map.put(:role, "owner")
  end

end