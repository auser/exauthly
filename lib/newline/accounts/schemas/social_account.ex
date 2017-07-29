defmodule Newline.Accounts.SocialAccount do
  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Newline.Repo

  schema "social_accounts" do
    field :provider, :string
    field :uid, :string

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
    |> cast(params, [:provider, :uid, :auth_token,
                    :refresh_token, :first_name, :last_name,
                    :email, :login_name, :user_id])
    |> validate_required([:provider, :uid])
    |> assoc_constraint(:user)
    |> unique_constraint(:provider, name: :provider_to_user_id_index, message: "has already been associated")
  end

  def changeset_from_auth(struct, "github", %Ueberauth.Auth{} = auth, user) do
    struct
    |> __MODULE__.changeset(params_from_ueberauth("github", auth, user))
  end
  def changeset_from_auth(_, _, _, _), do: {:error, :not_handled}

  def changeset_for_association(struct, provider, user) do
    struct
    |> __MODULE__.changeset(%{provider: provider, user_id: user.id})
  end

  def params_from_ueberauth("github", %Ueberauth.Auth{} = auth, user) do
    %{
      uid: uid,
      info: %Ueberauth.Auth.Info{name: name, email: email, nickname: nickname},
      credentials: %Ueberauth.Auth.Credentials{token: token, refresh_token: refresh_token}
    } = auth
    %{
      provider: "github",
      uid: uid,
      email: email,
      nickname: nickname,
      first_name: name,
      login_name: nickname,
      auth_token: token,
      refresh_token: refresh_token,
      user_id: user && user.id
    }
  end

end
