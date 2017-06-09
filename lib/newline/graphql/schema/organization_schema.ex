defmodule Newline.Schema.Organization do
  @moduledoc """
  Provides graphQL types for Organization
  """
  use Absinthe.Schema.Notation
  alias Newline.Resolvers.OrganizationResolver
  object :organization_fields do

    field :get_org_by_slug, type: :organization do
      arg :slug, non_null(:string)

      resolve &OrganizationResolver.get_org_by_slug/2
    end

  end

  object :organization_mutations do
    field :create_organization, type: :organization do
      arg :name, non_null(:string)
      arg :slug, non_null(:string)

      resolve &OrganizationResolver.create_organization/2
    end
  end
end
