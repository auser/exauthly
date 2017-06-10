defmodule Newline.Helpers.Validation do
  @moduledoc """
  Provides helpers for ecto validations
  """
  alias Ecto.Changeset
  # import Newline.Policies.BasePolicy, only: [member?: 2]


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
  def validate_member_of(%Changeset{} = cs, user, org_key) do
    Changeset.validate_change(cs, org_key, fn _, org_id ->
      case Newline.Policies.BasePolicy.member?(user, org_id) do
        true ->
          []
        false ->
          [current_organization: "user must belong to this organization to switch to it"]
      end
    end)
  end
  def validate_member_of(cs, _user, _field, _options \\ []), do: cs
end
