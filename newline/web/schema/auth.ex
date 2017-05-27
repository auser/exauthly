defmodule Newline.Schema.Auth do
  @moduledoc """
  Provides graphQL types or authentication
  """
  use Absinthe.Schema.Notation

  object :auth_mutations do

    field :login, type: :user do
      arg :email, non_null(:email)
      arg :password, non_null(:password)
      resolve &Newline.AuthResolver.login/2
    end

    field :reset_password_request, type: :boolean do
      arg :email, non_null(:string)

      resolve &Newline.AuthResolver.request_reset_password/2
    end

    field :password_reset, type: :user do
      arg :password, non_null(:string)
      arg :token, non_null(:string)

      resolve &Newline.AuthResolver.reset_password/2
    end
  end
end
