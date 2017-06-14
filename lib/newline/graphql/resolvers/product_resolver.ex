defmodule Newline.Resolvers.ProductResolver do
  import Newline.Resolvers.BaseResolver
  # import Newline.BasePolicy

  alias Newline.Products

  @doc """
  List products for user
  """
  def list_user_provider_products(%{provider: provider}, %{context: %{current_user: user}}) do
    Products.list_products(String.downcase(provider), user)
  end

  def list_user_provider_products(_, _), do: unauthorized_error()

end
