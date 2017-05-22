defmodule Newline.AuthResolver do
  import Newline.BaseResolver

  alias Newline.{UserService, User}

  @doc """
  Login with a user via email and password

  Example mutation

      mutation login($email:Email!,$password:String!) {
        login(email:$email, password: $password) {
          token
        }
      }
  """
  def login(params, _info), do: UserService.user_login(params)

  @doc """
  Request a password reset for the user

  Example mutation

      mutation reset_password_request($email:Email!) {
        reset_password_request(email:$email)
      }
  """
  def request_reset_password(%{email: email}, _), do: UserService.request_password_reset(email)
  

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
  def reset_password(%{password: password, token: token}, _) do
    case UserService.reset_password(token, password) do
      {:ok, user, token, _ } -> {:ok, Map.put(user, :token, token)}
      otherwise -> otherwise
    end
  end
end
