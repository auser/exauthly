defmodule Newline.Schema.Types.ProductTypes do
  use Absinthe.Schema.Notation

  object :product do
    field :id, :id
    field :name, :string
  end

end
