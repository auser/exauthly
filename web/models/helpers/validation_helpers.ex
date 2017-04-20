defmodule Newline.Helpers.Validation do
  alias Ecto.Changeset

  @doc """
  Validate a field as an email
  """
  def validate_email_format(%Changeset{} = changeset, field) when is_atom(field) do
    Changeset.validate_format(changeset, field, ~r/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end
  def validate_email_format(%Changeset{} = changeset, field) when is_list(field) do
    validate_email_format(changeset, String.to_atom(field))
  end
end
