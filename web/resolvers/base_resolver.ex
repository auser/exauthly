defmodule Newline.BaseResolver do
  def response({status, payload}) do
    IO.inspect(status)
    IO.inspect(payload)
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