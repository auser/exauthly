defmodule Newline.Schema.Auth do
  @moduledoc """
  Provides graphQL types or authentication
  """
  use Absinthe.Schema.Notation

  object :auth_mutations do

    field :login, type: :user do
      arg :email, non_null(:email)
      arg :password, non_null(:password)
      resolve &Newline.Resolvers.AuthResolver.login/2
    end

    field :social_login, type: :user do
      arg :uid, non_null(:string)
      arg :provider, non_null(:string)

      resolve &Newline.Resolvers.AuthResolver.social_login/2
    end

    field :reset_password_request, type: :boolean do
      arg :email, non_null(:string)

      resolve &Newline.Resolvers.AuthResolver.request_reset_password/2
    end

    field :password_reset, type: :user do
      arg :password, non_null(:string)
      arg :token, non_null(:string)

      resolve &Newline.Resolvers.AuthResolver.reset_password/2
    end
  end
end
