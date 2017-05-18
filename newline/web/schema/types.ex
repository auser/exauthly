defmodule Newline.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Newline.Repo

  object :user do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :email, :email

    field :token, :string
    field :current_organization, :organization
  end

  object :organization do
    field :id, :id
    field :name, :string
    field :members, list_of(:user)
    field :all, list_of(:user)
  end

  object :membership do
    field :id, :id
    field :organization, :organization
    field :role, :string
  end

  scalar :email do
    name "Email"
    description "User's Email"
    serialize fn(x) -> x end
    parse &Newline.Validators.EmailValidator.parse_and_validate_is_email(&1.value)
  end

  # object :session do
  #   field :token, :string
  # end

  input_object :update_user_params do
    field :first_name, :string
    field :last_name, :string
    field :email, :email
    field :password, :string
  end

end