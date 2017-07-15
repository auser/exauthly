defmodule Newline.Resolvers.AuthResolver do
  import Newline.Resolvers.BaseResolver

  alias Newline.Accounts

  @doc """
  Login with a user via email and password

  Example mutation

      mutation login($email:Email!,$password:String!) {
        login(email:$email, password: $password) {
          token
        }
      }
  """
  def login(params, _info), do: Accounts.user_login(params)

  @doc """
  Social authentication

  """
  def social_login(params, _info), do: Accounts.user_social_login(params)

  @doc """
  Request a password reset for the user

  Example mutation

      mutation reset_password_request($email:Email!) {
        reset_password_request(email:$email)
      }
  """
  def request_reset_password(%{email: email}, _info), do: Accounts.request_user_password_reset(email)
  def request_reset_password(_, _), do: invalid_request_error()


  @doc """
  Reset the user password

  Example mutation

      mutation reset_user_password($token:String!,$password:String!) {
        passwordReset(token:$token, password:$password) {
          email
          token
        }
      }
  """
  def reset_password(%{password: password, token: token}, _info) do
    case Accounts.reset_password(token, password) do
      {:ok, %{user: user, token: token}} ->
        {:ok, Map.put(user, :token, token)}
      otherwise ->
        otherwise
    end
  end
end
