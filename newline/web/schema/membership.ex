defmodule Newline.Schema.Types.Membership do
  use Absinthe.Schema.Notation

  alias Newline.{MembershipResolver}

  object :membership_fields do
    
    field :memberships, list_of(:membership) do
      resolve &MembershipResolver.user_memberships/2
    end

  end
  
  # object :org_mutations do
  # end
end
