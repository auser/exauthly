defmodule Newline.UserResolver do
  import Newline.BaseResolver
  import Newline.BasePolicy

  alias Newline.{UserService}
  
  def all(params, info) do
    UserService.get_all(params, info)
  end

  def email_available(%{email: email}, _info) do
    {:ok, UserService.check_email_availability(email)}
  end

  def create(params, _info) do
    UserService.user_signup(params)
  end

  def verify_user(%{verify_token: token}, _info) do
    UserService.verify_user(token) |> response
  end

  def me(_params, %{context: %{current_user: user}}) do
    UserService.get_me(user)
  end
end