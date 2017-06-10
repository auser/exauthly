defmodule Newline.Accounts.ValidationHelpersTest do
  use Newline.DataCase
  alias Newline.Repo
  alias Ecto.{Changeset}
  import Newline.Factory
  import Newline.Helpers.Validation

  describe "validate_email_format/2" do
    setup [:create_cs]
    test "with @ is a valid email format", %{cs: cs} do
      cs = cs
        |> Changeset.cast(%{email: "me@ari.io"}, [:email])
        |> validate_email_format(:email)
      assert cs.valid?
    end

    test "invalid tld is invalid", %{cs: cs} do
      cs = cs
        |> Changeset.cast(%{email: "me@bob."}, [:email])
        |> validate_email_format(:email)
      refute cs.valid?
    end

    test "invalid name is invalid", %{cs: cs} do
      cs = cs
        |> Changeset.cast(%{email: "@bob.com"}, [:email])
        |> validate_email_format(:email)
      refute cs.valid?
    end

    test "invalid domain", %{cs: cs} do
      cs = cs
        |> Changeset.cast(%{email: "ari@.com"}, [:email])
        |> validate_email_format(:email)
      refute cs.valid?
    end
  end

  describe "validate_slug/2" do
    # TODO
  end

  describe "validate_member_of/2" do
    setup [:create_cs, :create_user_and_join_org]

    test "is valid when user is a member", %{cs: cs, user: user, org: org} do
      cs = cs
      |> Changeset.cast(%{id: user.id, current_organization_id: org.id}, [:id, :current_organization_id])
      |> validate_member_of(user.id, :current_organization_id)
      assert cs.valid?
    end

    test "is invalid when not a member", %{cs: cs, user: user} do
      org = build(:organization) |> Repo.insert!
      cs = cs
      |> Changeset.cast(%{id: user.id, current_organization_id: org.id}, [:id, :current_organization_id])
      |> validate_member_of(user, :current_organization_id)
      refute cs.valid?
    end
  end

  defp create_cs(ctx) do
    data  = %{}
    types = %{email: :string, id: :integer, current_organization_id: :integer}
    cs = {data, types}
          |> Ecto.Changeset.cast(%{}, Map.keys(types))

    ctx
    |> Map.put(:cs, cs)
  end

  defp create_user_and_join_org(ctx) do
    membership = insert(:organization_membership)
    ctx
    |> Map.put(:user, membership.member)
    |> Map.put(:org, membership.organization)
    |> Map.put(:membership, membership)
  end
end
