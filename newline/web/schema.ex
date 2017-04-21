defmodule Newline.Schema do
  use Absinthe.Schema
  import_types Newline.Schema.Types

  query do
    field :users, list_of(:user) do
      resolve &Newline.UserResolver.all/2
    end
    field :organizations, list_of(:organization) do
      resolve &Newline.OrganizationResolver.all/2
    end
  end

  mutation do

    field :signup_with_email_and_password, type: :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      arg :first_name, :string
      arg :last_name, :string

      resolve &Newline.UserResolver.create/2
    end

    # field :update_user, type: :user do
    #   arg :id, non_null(:integer)
    #   arg :user, :update_user_params

    #   resolve &Newline.UserResolver.update/2
    # end

    field :create_organization, type: :organization do
      arg :name, non_null(:string)

      resolve &Newline.OrganizationResolver.create_organization/2
    end

    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Newline.UserResolver.login/2
    end
  end

end