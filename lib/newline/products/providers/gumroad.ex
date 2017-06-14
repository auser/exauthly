defmodule Newline.Products.Providers.Gumroad do

  @base_url "https://api.gumroad.com"

  def list_products(social_account) do
    access_token = social_account.auth_token
    url = @base_url <> "/v2/products?" <> URI.encode_query(%{access_token: access_token})
    case HTTPoison.get! url do
      %HTTPoison.Response{body: body} ->
        body
          |> Poison.decode!
          |> Map.get("products")
          |> Enum.map(fn (product) -> IO.inspect(product) end)
          # |> Enum.reduce(%{}, fn ({key, val}, acc) -> Map.put(acc, String.to_atom(key), val) end)
      other -> other
    end
  end

end
