defmodule Newline.Accounts.OrganizationServiceTest do
  use Newline.DataCase

  import Newline.Factory
  alias Newline.Accounts.OrganizationService

  describe "get_org_by_slug/1" do
    test "it gets the organization if it exists" do
      org = build(:organization) |> Repo.insert!
      {:ok, org} = OrganizationService.get_org_by_slug(org.slug)
      assert org
    end

    test "it fails when it can't find an org" do
      {:error, :not_found} = OrganizationService.get_org_by_slug("not_a_slug")
    end
  end

  describe "create_organization/2" do
    test "should create an org with valid params" do
      params = params_for(:organization)
      {:ok, _} = OrganizationService.create_organization(params)
    end

    test "returns an error for missing params" do
      {:error, :bad_request} = OrganizationService.create_organization(%{})
    end

    test "returns an error from the changeset if invalid" do
      params = params_for(:organization, %{name: "iex"})
      {:error, cs} = OrganizationService.create_organization(params)
      refute cs.valid?
      assert cs.errors[:name]
    end
  end

  describe "join_org/2" do
    setup [:create_organization, :create_user]

    # TODO
    # test "adds a membership to the organization", %{org: org, user: user} do
    #   {:ok, _} = OrganizationService.join_org(org, user)
    # end
  end

  def create_organization(context) do
    context
    |> Map.put(:org, build(:organization))
  end

  def create_user(context) do
    context
    |> Map.put(:user, build(:user))
  end

end
