defmodule Newline.Schema.Types.UserTypes do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :email, :email
    field :verified, :boolean

    field :token, :string
    field :admin, :boolean
    field :gumroad_id, :string do
      resolve fn (user, _, _) ->
        case Newline.Accounts.get_social_account(user, :gumroad) do
          {:error, :not_found} -> {:ok, nil}
          {:ok, id} -> {:ok, id}
        end
      end
    end
  end

  object :availability_status do
    field :available, :boolean
    field :valid, :boolean
  end
end
