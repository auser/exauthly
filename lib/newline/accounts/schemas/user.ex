defmodule Newline.Accounts.User do
  use Ecto.Schema
  import Newline.Helpers.Validation
  import Ecto.{Query, Changeset}, warn: false
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  alias Newline.Accounts.{SocialAccount}

  @derive {Poison.Encoder, only: [:email, :name, :admin]}
  schema "users" do
    field :name, :string
    field :email, :string
    field :username, :string

    field :password, :string, virtual: true
    field :encrypted_password, :string

    field :admin, :boolean, default: false

    field :password_reset_token, :string
    field :password_reset_timestamp, Timex.Ecto.DateTime

    field :verified, :boolean, default: false
    field :verify_token, :string

    has_many :social_accounts, Newline.Accounts.SocialAccount

    has_many :organization_memberships, Newline.Accounts.OrganizationMembership, foreign_key: :member_id
    has_many :organizations, through: [:organization_memberships, :organization]
    belongs_to :current_organization, Newline.Accounts.Organization

    timestamps()
  end

  def user_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :username])
    |> validate_required([:email])
    |> validate_length(:username, min: 1, max: 40)
    |> validate_length(:email, min: 3)
    |> validate_email_format(:email)
    |> unique_constraint(:email, message: "Email already taken")
    |> downcase_user_email
  end

  def registration_changeset(user, attrs) do
    user
    |> user_changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> generate_encrypted_password
    |> put_token(:verify_token)
  end

  def social_registration_changeset(user, attrs) do
    user
    |> user_changeset(attrs)
    |> generate_encrypted_password
    |> put_token(:verify_token)
  end

  def reset_password_request_changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> put_change(:password_reset_timestamp, Timex.now)
    |> put_token(:password_reset_token)
  end

    # When a user comes back with a token
  def reset_password_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 5, max: 128)
    |> put_change(:password_reset_token, nil)
    |> put_change(:password_reset_timestamp, nil)
    |> generate_encrypted_password
  end

  @doc """
  Changeset for updating a user's password
  """
  def change_password_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 5, max: 128)
    |> generate_encrypted_password
  end

  def social_account_changeset(user, params \\ %{}) do
    user_id = if (user == nil), do: nil, else: user.id
    %SocialAccount{}
    |> SocialAccount.changeset(params)
    # |> assoc_constraint(:user, user)
    |> put_change(:user_id, user_id)
  end

  @doc """
  Changeset for verifying a user
  """
  def verifying_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:verify_token])
    |> validate_required([:verify_token])
    |> put_change(:verified, true)
    |> put_change(:verify_token, nil)
  end


  @doc """
  Update a user's changeset
  """
  def update_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :email])
    |> update_change(:email, &String.downcase/1)
    |> validate_email_format(:email)
    |> unique_constraint(:email, message: "Email already taken")
    # |> validate_inclusion(:role, OrganizationMembership.roles())
  end

  def current_organization_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:current_organization_id])
    |> validate_required([:current_organization_id])
    |> foreign_key_constraint(:current_organization_id)
    |> assoc_constraint(:current_organization)
    |> validate_member_of(:current_organization_id)
  end

  ########################################

  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, hashpwsalt(password))
      %Ecto.Changeset{valid?: true} ->
        random_pass = generate_token()
        put_change(current_changeset, :encrypted_password, random_pass)
      _ ->
        current_changeset
    end
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

  defp downcase_user_email(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{email: email}} ->
        put_change(changeset, :email, String.downcase(email))
      _ ->
        changeset
    end
  end
end
