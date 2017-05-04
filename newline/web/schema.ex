defmodule Newline.Schema do
  use Absinthe.Schema
  import_types Newline.Schema.Types
  import_types Newline.Schema.Types.Auth
  import_types Newline.Schema.Types.User
  import_types Newline.Schema.Types.Org

  query do
    import_fields :user_fields
    import_fields :org_fields

    # field :organizations, list_of(:organization) do
    #   resolve &Newline.OrganizationResolver.all/2
    # end
  end

  mutation do

    import_fields :auth_mutations
    import_fields :user_mutations
    # import_fields :org_mutations

    field :create_organization, type: :organization do
      arg :name, non_null(:string)

      resolve &Newline.OrganizationResolver.create_organization/2
    end

  end

end