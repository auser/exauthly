defmodule Newline.Schema.Organization do
  @moduledoc """
  Provides graphQL types for Organization
  """
  use Absinthe.Schema.Notation

  object :organization_fields do

    field :get_org_by_slug, type: :organization do
      arg :slug, non_null(:string)

      resolve &Newline.Resolvers.OrganizationResolver.get_org_by_slug/2
    end

  end

  # object :organization_mutations do

  # end
end
