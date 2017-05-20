defmodule Newline.Schema.Types.Org do
  use Absinthe.Schema.Notation

  alias Newline.{OrganizationResolver}

  object :org_fields do
    
    field :organizations, type: list_of(:organization) do
      resolve &OrganizationResolver.all/2
    end

  end
  
  # object :org_mutations do
  # end
end
