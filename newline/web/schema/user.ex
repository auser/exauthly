defmodule Newline.Schema.Types.User do
  use Absinthe.Schema.Notation

  object :user_fields do
    field :users, list_of(:user) do
      resolve &Newline.UserResolver.all/2
    end

    field :me, :user do
      resolve &Newline.UserResolver.me/2
    end

  end

  object :user_mutations do
    field :signup_with_email_and_password, type: :user do
      arg :email, non_null(:email)
      arg :password, non_null(:string)

      arg :name, :string

      resolve &Newline.UserResolver.create/2
    end
  end
end