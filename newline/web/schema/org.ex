defmodule Newline.Schema.Types.Org do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias Newline.{OrganizationResolver}

  object :org_fields do
    
    field :organizations, type: list_of(:organization) do
      resolve &OrganizationResolver.all/2
    end

  end
  
  object :org_mutations do
    field :create_organization, type: :organization do
      arg :name, non_null(:string)

      resolve &Newline.OrganizationResolver.create_organization/2
    end

  end
end
