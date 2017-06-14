defmodule Newline.Schema.Product do
  use Absinthe.Schema.Notation

  object :product_queries do
    field :list_products, list_of(:product) do
      arg :provider, non_null(:string)

      resolve &Newline.Resolvers.ProductResolver.list_user_provider_products/2
    end
  end

  # object :product_mutations do
  # end
end
