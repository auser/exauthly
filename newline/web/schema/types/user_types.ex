defmodule Newline.Schema.Types.UserTypes do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :email, :email

    field :token, :string
    field :current_organization, :organization
  end
end