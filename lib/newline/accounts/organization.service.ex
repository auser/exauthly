defmodule Newline.Accounts.OrganizationService do
  @moduledoc """
  The boundary for the Organizations system.
  """
  alias Newline.Repo
  import Ecto.{Query, Changeset}, warn: false

  alias Newline.Accounts.{User, Organization}

  @doc """
  Gets the organization from the slug
  """
  def get_org_by_slug(slug) do
    query = Organization
    |> where([o], o.slug == ^slug)

    case Repo.one(query) do
      nil ->
        {:error, :not_found}
      org ->
        {:ok, org}
    end
  end
end
