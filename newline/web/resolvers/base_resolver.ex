defmodule Newline.BaseResolver do

  import Canada, only: [can?: 2]
  alias Newline.{Repo, User}

  @unauthorized_error {:error, "Unauthorized"}
  @unauthenticated_error {:error, "User not logged in"}

  def unauthenticated_error, do: @unauthenticated_error
  def unauthorized_error, do: @unauthorized_error

  def response({status, payload}) do
    case payload do
      %Ecto.Changeset{} = changeset ->
        {
          status,
          message: "Validation failed.",
          changeset: %{
            errors: changeset
            |> Ecto.Changeset.traverse_errors(fn
              {msg, opts} -> String.replace(msg, "%{count}", to_string(opts[:count]))
              msg -> msg
            end),
            action: changeset.action
          }
        }
      _ -> {status, payload}
    end
  end
end