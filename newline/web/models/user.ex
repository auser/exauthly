defmodule Newline.User do
  use Newline.Web, :model

  alias Newline.Repo
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Newline.Helpers.Validation

  @derive {Poison.Encoder, only: [:email, :first_name, :last_name, :admin]}
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string

    field :password, :string, virtual: true
    field :encrypted_password, :string

    field :role, :string, default: "user"
    field :admin, :boolean, default: false
    
    field :password_reset_token, :string
    field :password_reset_timestamp, Timex.Ecto.DateTime

    has_many :organization_memberships, Newline.OrganizationMembership, foreign_key: :member_id
    has_many :organizations, through: [:organization_memberships, :organization]
    belongs_to :current_organization, Newline.Organization

    timestamps()
  end

  @valid_name_length [min: 1, max: 64]
  @valid_password_length [min: 5, max: 128]
  @valid_roles ~w(user admin superadmin)

  def valid_name_length, do: @valid_name_length
  def valid_roles, do: @valid_roles

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email])
    |> validate_required([:email])
    |> validate_email_format(:email)
  end

  # When a user signs up
  def signup_changeset(user, params \\ %{}) do
    user
    |> __MODULE__.changeset(params)
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email, message: "Email already taken")
    |> validate_length(:password, @valid_password_length)
    |> generate_encrypted_password
  end

  # When a user requests a password reset
  def reset_password_request_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:email])
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

  # When a user is getting updated
  def update_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:first_name, :last_name, :email, :admin, :current_organization_id])
    |> update_change(:email, &String.downcase/1)
    |> validate_email_format(:email)
    |> unique_constraint(:email, message: "Email already taken")
    |> foreign_key_constraint(:current_organization_id)
    |> assoc_constraint(:current_organization)
  end

  def authenticate_by_email_and_pass(%{email: email, password: password} = _params) do
    user = Repo.get_by(Newline.User, email: String.downcase(email))
    cond do
      check_user_password(user, password) -> {:ok, user}
      user ->
        {:error, "Your password does not match with the password we have on record"}
      true ->
        dummy_checkpw()
        {:error, "We couldn't find a user associated with the email #{email}"}
    end
  end
  def authenticate_by_email_and_pass(_), do: {:error, "bad_credentials"}

  @doc """
  Check a user's password with bcrypt'
  """
  def check_user_password(user, password) do
    user && checkpw(password, user.encrypted_password)
  end

  # Helpers
  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        current_changeset
    end
  end

  # Token
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
