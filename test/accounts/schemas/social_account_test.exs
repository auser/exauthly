defmodule Newline.SocialAccountTest do
  use Newline.SchemaCase
  import Newline.Factory
  alias Newline.Repo
  alias Newline.Accounts.SocialAccount

  describe "changeset/2" do
    setup [:create_user]

    test "creates a valid account with required params" do
      acc = params_with_assocs(:social_account)
      cs = SocialAccount.changeset(%SocialAccount{}, acc)
      assert cs.valid?
    end

    test "associates a user with the account" do
      sa = insert(:social_account)
      assert sa.user != nil
    end

    test "requires social_account_name" do
      acc = params_with_assocs(:social_account, %{social_account_name: nil})
      cs = SocialAccount.changeset(%SocialAccount{}, acc)
      refute cs.valid?
    end

    test "requires social_account_id" do
      acc = params_with_assocs(:social_account, %{social_account_id: nil})
      cs = SocialAccount.changeset(%SocialAccount{}, acc)
      refute cs.valid?
    end

    test "cannot create the same social auth network with the same user" do
      acc = params_with_assocs(:social_account, %{social_account_name: "Facebook"})
      cs = SocialAccount.changeset(%SocialAccount{}, acc)
      assert cs.valid?
      Repo.insert!(cs)
      acc = params_for(:social_account, %{social_account_name: "Facebook", user_id: acc[:user_id]})
      cs = SocialAccount.changeset(%SocialAccount{}, acc)

      {:error, cs} = Repo.insert(cs)
      refute cs.valid?
      assert cs.errors[:social_account_name] != nil
    end

  end

  defp create_user(ctx) do
    ctx
    |> Map.put(:user, build(:user))
  end
end
