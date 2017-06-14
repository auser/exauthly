defmodule Newline.Products do

  alias Newline.Accounts
  alias Newline.Products.Providers.{Gumroad}

  def list_products(provider, user) when is_atom(provider), do: list_products(to_string(provider), user)
  def list_products("gumroad", user) do
    case Accounts.get_social_account(user, "gumroad") do
      {:error, :not_found} -> {:error, :not_found}
      {:ok, social_account} ->
        Gumroad.list_products(social_account)
    end
  end

end
