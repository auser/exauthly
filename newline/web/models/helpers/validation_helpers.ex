defmodule Newline.Helpers.Validation do
  @moduledoc """
  Provides helpers for ecto validations
  """
  alias Ecto.Changeset
  # import Newline.BasePolicy, only: [member?: 2]


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

  # @doc """
  # Validates a user is a member of an organization
  # """
  # def validate_member_of(%Changeset{} = cs, user) do
  #   Changeset.validate_change(cs, :current_organization_id, fn _, org_id ->
  #     case Newline.BasePolicy.member?(cs, user) do
  #       true -> []
  #       false ->
  #         [current_organization: "user must belong to this organization to switch to it"]
  #     end
  #   end)
  # end
  # def validate_member_of(cs, field, options \\ []), do: cs
end
