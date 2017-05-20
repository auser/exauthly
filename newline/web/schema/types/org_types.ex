defmodule Newline.Schema.Types.OrgTypes do
  use Absinthe.Schema.Notation

  object :organization do
    field :id, :id
    field :name, :string
    field :members, list_of(:user)
    field :all, list_of(:user)
    field :slug, :string
  end

end