defmodule Newline.Invitation do
  @moduledoc """
    An invitation
  """
  use Newline.Web, :model
  alias Newline.{Organization, User}

  schema "invitations" do
    belongs_to :organization, Organization
    belongs_to :user, User
    belongs_to :invitee, User
    field :token, :string
    field :accepted, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def create_changeset(struct, params \\ %{}) do
    struct 
    |> cast(params, [])
    |> put_assoc(:user, params.user)
    |> put_assoc(:organization, params.organization)
    |> put_assoc(:invitee, params.invitee)
    |> assoc_constraint(:user)
    |> assoc_constraint(:organization)
    |> assoc_constraint(:invitee)
    |> put_token(:token)
  end

    defp put_token(changeset, field) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        # Valid changeset
        token = generate_token()
        put_change(changeset, field, token)
      _ ->
        changeset
    end
  end

  defp generate_token do
    50
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64
    |> binary_part(0, 50)
  end
end
