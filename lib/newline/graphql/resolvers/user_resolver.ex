defmodule Newline.Resolvers.UserResolver do
  import Newline.Resolvers.BaseResolver
  # import Newline.BasePolicy

  alias Newline.Accounts

  @doc """
  Get a list of all the users

  ## Examples

      query list_users { id }
  """
  def list_users(_params, %{context: %{current_user: %{admin: true}}}) do
    Accounts.list_users()
  end
  def list_users(_, _), do: unauthorized_error()

  @doc """
  Check to see if an email is available

  ## Examples

      query checkEmail($email:Email!){
        checkEmailAvailability(email:$email)
      }
  """
  def check_email_availability(%{email: email}, _info) do
    {:ok, Accounts.check_email_availability(email)}
  end

  @doc """
  Create a new user by parameters

  ## Examples

      mutation createUser($email:Email!, $password:Password!, $name:string!) {
        signupWithEmailAndPassword(
          email:$email,
          password:$password,
          name:$name
        ) {
          token
        }
      }
  """
  def create_user(params, _info) do
    Accounts.create_user(params)
  end

  @doc """
  Verify a user's email

  ## Examples

      mutation verifyUser($verify_token:String!){
        verifyUser(verifyToken:$verify_token){
          email
          verified
        }
      }
  """
  def verify_user(%{verify_token: token}, _info) do
    Accounts.verify_user(token)
  end
  def verify_user(_, _), do: {:error, :invalid}

  @doc """
  Get the currently logged in user

  ## Examples

      query {
        me {
          email
          name
          id
        }
      }
  """
  def me(_params, %{context: %{current_user: user}}) do
    user = Accounts.get_user!(user.id)
    {:ok, user}
  end
  def me(_params, _), do: unauthenticated_error()

  @doc """
  Update the current user

  ## Examples

      mutation updateUser(
        $email: Email,
        $name: String,
        $username: String
      ) {
        updateUser(
          email:$email,name:$name,username:$username
        ) {
          id
          email
        }
      }
  """
  def update_user(params, %{context: %{current_user: user}}) do
    Accounts.update_user(user, params)
  end
  def update_user(params, _), do: unauthenticated_error()

end
