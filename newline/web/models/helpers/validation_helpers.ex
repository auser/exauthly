defmodule Newline.Helpers.Validation do
  alias Ecto.Changeset

  @doc """
  Validate a field as an email
  """
  def validate_email_format(%Changeset{} = changeset, field) when is_atom(field) do
    Changeset.validate_format(changeset, field, ~r/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end

  @doc """
  Validates a slug

  https://github.com/code-corps/code-corps-api/blob/develop/lib/code_corps/validators/slug_validator.ex
  """
  def validate_slug(changeset, field_name) do
    valid_slug_pattern = ~r/\A((?:(?:(?:[^-\W]-?))*)(?:(?:(?:[^-\W]-?))*)\w+)\z/
    changeset
    |> Changeset.validate_format(field_name, valid_slug_pattern)
  end
end
