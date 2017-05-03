defmodule Newline.OrganizationTest do
  use Newline.ModelCase
  import Newline.Factory
  alias Newline.{Organization}

  setup do
    {:ok, 
      user: build(:user),
      org: build(:organization)}
  end

  test "is created with valid name" do
    cs = Organization.create_changeset(%Organization{}, %{name: "Fullstack.io"})
    assert cs.valid?
  end

  test "fails to be created without a name" do
    cs = Organization.create_changeset(%Organization{})
    refute cs.valid?
  end

end