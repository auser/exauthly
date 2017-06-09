defmodule Newline.Accounts.OrganizationService do
  @moduledoc """
  The boundary for the Organizations system.
  """
  alias Newline.Repo
  import Ecto.{Query, Changeset}, warn: false

  alias Newline.Accounts.{User, Organization, OrganizationMembership}

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

  @doc """
  Create an organization with slug and name
  """
  def create_organization(%{name: _, slug: _} = params) do
    Organization.create_changeset(%Organization{}, params)
    |> Repo.insert
  end
  def create_organization(_), do: {:error, :bad_request}

  @doc """
  Add member to organization
  """
  def join_org(%Organization{} = org, %User{} = user, opts \\ %{}) do
    params = %{
      organization_id: org.id,
      member_id: user.id,
      role: opts[:role]
    }
    %OrganizationMembership{}
    |> OrganizationMembership.create_changeset(params)
    |> Repo.insert
  end

end
