defmodule Newline.Schema.User do
  use Absinthe.Schema.Notation

  object :user_fields do
    field :users, list_of(:user) do
      resolve &Newline.Resolvers.UserResolver.list_users/2
    end

    field :me, :user do
      resolve &Newline.Resolvers.UserResolver.me/2
    end

    field :check_email_availability, type: :boolean do
      arg :email, non_null(:email)

      resolve &Newline.Resolvers.UserResolver.check_email_availability/2
    end

  end

  object :user_mutations do
    field :signup_with_email_and_password, type: :user do
      arg :email, non_null(:email)
      arg :password, non_null(:string)

      arg :name, :string

      resolve &Newline.Resolvers.UserResolver.create_user/2
    end

    field :verify_user, type: :user do
      arg :verify_token, non_null(:string)

      resolve &Newline.Resolvers.UserResolver.verify_user/2
    end

    field :update_user, type: :user do
      arg :name, :string
      arg :email, :email
      arg :username, :string

      resolver &Newline.Resolvers.UserResolver.update_user/2
    end
  end
end
