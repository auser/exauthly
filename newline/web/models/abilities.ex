defmodule Canary.Abilities do
  alias Newline.{User}
  alias Ecto.Changeset

  defimpl Canada.Can, for: User do

    def can?(%User{}, _action, nil), do: true

  end
end