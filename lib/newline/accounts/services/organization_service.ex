defmodule Newline.Accounts.OrganizationService do
  @moduledoc """
  The boundary for the Organizations system.
  """
  alias Newline.Repo
  import Ecto.{Query, Changeset}, warn: false
  alias Ecto.Multi

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
List all organizations a user is a member

  ## Examples

      > list_user_org(user)
      {:ok, []}
  """
  def list_user_orgs(user) do
    query = OrganizationMembership
            |> where([m], m.member_id == ^user.id)

    case Repo.all(query) do
      [] -> {:ok, []}
      other -> {:ok, other}
    end
  end

  @doc """
  Create and join the organization as the owner
  """
  def create_and_join(user, org) do
    case Repo.transaction(create_and_join_transaction(user, org)) do
      {:error, _failed_op, failed_cs, _changes} ->
        {:error, failed_cs}
      {:ok, %{join_org: org}} ->
        {:ok, org}
      other ->
        IO.puts "HUh? #{inspect(other)}"
    end
  end

  defp create_and_join_transaction(user, org) do
    org_cs = Organization.create_changeset(%Organization{}, org)
    Multi.new
    |> Multi.insert(:organization, org_cs)
    |> Multi.run(:join_org, &(join_org(user, &1[:organization], %{role: "owner"})))
  end

  @doc """
  Add member to organization
  """
  def join_org(user, org, opts \\ %{})
  def join_org(%User{} = user, org_id, opts) when is_number(org_id) do
    org = Repo.get(Organization, org_id)
    join_org(user, org, opts)
  end
  def join_org(%User{} = user, org_slug, opts) when is_binary(org_slug) do
    case get_org_by_slug(org_slug) do
      nil -> {:error, :not_found}
      {:ok, org} ->
        join_org(user, org, opts)
    end
  end
  def join_org(%User{} = user, %Organization{} = org, opts) do
    params = %{
      organization_id: org.id,
      member_id: user.id,
      role: opts[:role]
    }
    %OrganizationMembership{}
    |> OrganizationMembership.create_changeset(params)
    |> Repo.insert
  end
  def join_org(_, _, _), do: {:error, :bad_request}

end
