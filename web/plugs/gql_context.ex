defmodule Newline.Plug.Context do
  @moduledoc """
  This plug adds the context argument to GraphQL requests
  """
  @behaviour Plug

  import Plug.Conn
  alias Newline.{GuardianSerializer}

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})
      _ ->
        conn
    end
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    case Guardian.Plug.current_token(conn) do
      nil -> 
        {:error, "No authorization token"}
      current_token ->
        with {:ok, claims} <- Guardian.decode_and_verify(current_token),
            {:ok, user} <- GuardianSerializer.from_token(claims["sub"]) do
              {:ok, %{current_user: user, admin: user.admin}}
        else
          {:error, _reason} -> {:error, "Invalid authorization token"}
        end
    end
  end

end