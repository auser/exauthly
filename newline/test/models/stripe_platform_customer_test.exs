defmodule Newline.StripePlatformCustomerTest do
  use Newline.ModelCase

  alias Newline.StripePlatformCustomer

  @valid_attrs %{currency: "some content", delinquent: true, email: "some content", stripe_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StripePlatformCustomer.changeset(%StripePlatformCustomer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StripePlatformCustomer.changeset(%StripePlatformCustomer{}, @invalid_attrs)
    refute changeset.valid?
  end
end
