defmodule Newline.Schema.Invitation do
  @moduledoc """
  Provides graphQL types or authentication
  """
  use Absinthe.Schema.Notation

  object :invitation_mutations do

    field :invite_user, type: :invitation do
      arg :email, non_null(:email)
      resolve &Newline.InvitationResolver.create/2
    end

  end

  # object :invitation_queries do
  # end
end
