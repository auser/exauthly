defmodule Newline.OrganizationResolver do
  import Newline.BaseResolver, only: [response: 1]

  alias Newline.{Organization, Repo, OrganizationService}
  
  def all(_args, %{context: %{current_user: user}}) when not is_nil(user) do
    case user.admin do
      true -> {:ok, Repo.all(Organization)}
      _ -> {:ok, user}
    end
  end
  def all(_, _), do: {:error, "Unauthorized"}

end