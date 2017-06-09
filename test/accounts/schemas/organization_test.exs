defmodule Newline.OrganizationTest do
  use Newline.SchemaCase
  import Newline.Factory
  alias Newline.Repo
  alias Newline.Accounts.Organization

  describe "changeset/2" do
    test "creates one successfully with valid params" do
      org = params_for(:organization)
      cs = Organization.changeset(%Organization{}, org)
      assert cs.valid?
    end
    test "fails without a name" do
      org = params_for(:organization, %{name: nil})
      cs = Organization.changeset(%Organization{}, org)
      refute cs.valid?
    end
    test "fails without a slug" do
      org = params_for(:organization, %{slug: nil})
      cs = Organization.changeset(%Organization{}, org)
      refute cs.valid?
    end
    test "fails if a name is too short" do
      org = params_for(:organization, %{name: "nil"})
      cs = Organization.changeset(%Organization{}, org)
      refute cs.valid?
    end
    test "fails if the name is a duplicate" do
      build(:organization, %{name: "ElixirBridge"}) |> Repo.insert!
      org = params_for(:organization, %{name: "ElixirBridge"})
      cs = Organization.changeset(%Organization{}, org)
      {:error, cs} = cs |> Repo.insert
    end
  end
end
