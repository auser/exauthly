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

    field :admin, :boolean, default: false
    
    field :password_reset_token, :string
    field :password_reset_timestamp, Timex.Ecto.DateTime

    timestamps()
  end

  # When a user signs up
  def signup_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> update_change(:email, &String.downcase/1)
    |> validate_email_format(:email)
    |> unique_constraint(:email, message: "Email already taken")
    |> validate_length(:password, min: 5, max: 128)
    |> generate_encrypted_password
  end

  # When a user is getting updated
  def update_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:first_name, :last_name, :email, :admin])
    |> update_change(:email, &String.downcase/1)
    |> validate_email_format(:email)
    |> unique_constraint(:email, message: "Email already taken")
  end

  def authenticate_by_email_and_pass(%{email: email, password: password} = _params) do
    user = Repo.get_by(Newline.User, email: String.downcase(email))
    cond do
      user && checkpw(password, user.encrypted_password) ->
        {:ok, user}
      user ->
        {:error, "Your password does not match with the password we have on record"}
      true ->
        dummy_checkpw()
        {:error, "We couldn't find a user associated with the email #{email}"}
    end
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
end
