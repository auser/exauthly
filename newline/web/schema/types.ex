defmodule Newline.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Newline.Repo

  import_types Newline.Schema.Types.Global
  import_types Newline.Schema.Types.UserTypes

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

  object :success_type do
    field :success, :boolean
  end

  # object :session do
  #   field :token, :string
  # end

  input_object :update_user_params do
    field :name, :string
    field :email, :email
    field :password, :string
  end

end
