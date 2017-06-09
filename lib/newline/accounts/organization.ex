defmodule Newline.Accounts.Organization do
  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Newline.Repo

  schema "organizations" do
    field :name, :string
    field :slug, :string

    # has_many :organization_memberships, OrganizationMembership
    # has_many :members, through: [:organization_memberships, :member]

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :slug])
    |> validate_required([:name, :slug])
    |> validate_length(:name, min: 5, max: 255)
    |> unique_constraint(:name, message: "Organization name already taken")
  end

  @doc """
  Create an organization

  ## Examples

    iex> Organization.create_changeset(%Newline.Organization{}, %{name: "Fullstack.io"})
  """
  @spec create_changeset(struct, map) :: Ecto.Changeset
  def create_changeset(org, params \\ %{}) do
    org
    |> changeset(params)
    # |> generate_slug(:name, :slug)
  end

  @doc """
  Update an organization
  """
  def update_changeset(org, params \\ %{}) do
    org
    |> changeset(params)
  end

  # defp generate_slug(changeset, value_key, slug_key) do
  #   case changeset do
  #     %Changeset{valid?: true, changes: changes} ->
  #       case Map.fetch(changes, value_key) do
  #         {:ok, value} -> Changeset.put_change(changeset, slug_key, Inflex.parameterize(value))
  #         _ -> changeset
  #       end
  #     _ -> changeset
  #   end
  # end
end
