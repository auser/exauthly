defmodule Newline.Schema.Types.UserTypes do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :email, :email
    field :verified, :boolean

    field :token, :string
    field :admin, :boolean
    field :gumroadId, :string do
      complexity 10
    end
  end

  object :availability_status do
    field :available, :boolean
    field :valid, :boolean
  end
end
