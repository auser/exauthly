defmodule Newline.Schema.Types.InvitationTypes do
  use Absinthe.Schema.Notation

  object :invitation do
    field :invitee, :user
    field :user, :user
    field :organization, :organization

    field :accepted, :boolean

    field :id, :id
  end

end