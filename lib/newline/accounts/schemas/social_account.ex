defmodule Newline.Accounts.SocialAccount do
  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Newline.Repo

  schema "social_accounts" do
    field :social_account_name, :string
    field :social_account_id, :string

    field :auth_token, :string
    field :refresh_token, :string

    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :login_name, :string

    belongs_to :user, Newline.Accounts.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    # user = Repo.one()
    struct
    |> Repo.preload(:user)
    |> cast(params, [:social_account_name, :social_account_id, :auth_token,
                    :refresh_token, :first_name, :last_name,
                    :email, :login_name, :user_id])
    |> validate_required([:social_account_name, :social_account_id])
    |> assoc_constraint(:user)
    |> unique_constraint(:social_account_name, name: :social_account_name_to_user_id_index, message: "has already been associated")
  end

end
