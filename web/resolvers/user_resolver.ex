defmodule Newline.UserResolver do
  import Newline.BaseResolver, only: [response: 1]
  import Newline.BasePolicy, only: [site_admin?: 1]

  alias Newline.{User, Repo, UserService}
  
  def all(_args, %{context: %{current_user: user}}) when not is_nil(user) do
    case site_admin?(user) do
      true -> {:ok, Repo.all(User)}
      _ -> {:ok, user}
    end
  end
  def all(_, _), do: {:error, "Unauthorized"}

  def create(params, _info) do
    UserService.user_signup(params) |> response
  end

  # def update(%{id: id, user: user_params}, _info) do
  #   Repo.get!(User, id)
  #   |> User.update_changeset(user_params)
  #   |> Repo.update
  # end

  def login(params, _info) do
    claims = Guardian.Claims.app_claims
    |> Map.put("user", true)
    |> Guardian.Claims.ttl({30, :days})

    with  {:ok, acc} <- User.authenticate_by_email_and_pass(params),
          {:ok, jwt, _} <- Guardian.encode_and_sign(acc, :access, claims) do
          {:ok, %{token: jwt}}
    end
  end
end