defmodule Newline.Schema do
  @moduledoc """
  Provides a top-level, global configuration of the Absinthe/GraphQL
  schema. Look in the submodules for the definitions of these graphql
  types and mutations. 
  """

  use Absinthe.Schema
  import_types Newline.Schema.Types
  import_types Newline.Schema.Types.Auth
  import_types Newline.Schema.Types.User
  import_types Newline.Schema.Types.Org
  import_types Newline.Schema.Types.Membership

  query do
    import_fields :user_fields
    import_fields :org_fields
    import_fields :membership_fields
  end

  mutation do

    import_fields :auth_mutations
    import_fields :user_mutations
    import_fields :org_mutations

  end

end