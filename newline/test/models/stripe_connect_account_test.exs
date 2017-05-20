defmodule Newline.StripeConnectAccountTest do
  use Newline.ModelCase

  alias Newline.StripeConnectAccount

  @valid_attrs %{business_name: "some content", business_url: "some content", charges_enabled: true, stripe_id: "1234", organization_id: 1, tos_acceptance_date: Timex.now}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StripeConnectAccount.create_changeset(%StripeConnectAccount{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StripeConnectAccount.create_changeset(%StripeConnectAccount{}, @invalid_attrs)
    refute changeset.valid?
  end
end
