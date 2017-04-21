defmodule Newline.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Newline.Repo

  object :user do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :email, :string

    field :token, :string
    field :current_organization, :organization
  end

  object :organization do
    field :name, :string
    field :members, list_of(:user)
    field :all, list_of(:user)
  end

  object :session do
    field :token, :string
  end

  input_object :update_user_params do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string
  end

end