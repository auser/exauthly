defmodule Newline.Accounts.OrganizationServiceTest do
  use Newline.DataCase

  import Newline.Factory
  alias Newline.Accounts.OrganizationService
  alias Newline.Accounts.User

  describe "get_ogr_by_slug/1" do
    test "it gets the organization if it exists" do
      org = build(:organization) |> Repo.insert!
      {:ok, org} = OrganizationService.get_org_by_slug(org.slug)
      assert org
    end

    test "it fails when it can't find an org" do
      {:error, :not_found} = OrganizationService.get_org_by_slug("not_a_slug")
    end
  end

end
