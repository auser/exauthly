defmodule Newline.Schema.Types.OrganizationTypes do
  use Absinthe.Schema.Notation

  object :organization do
    field :id, :id
    field :name, :string
    field :slug, :string
  end

end
