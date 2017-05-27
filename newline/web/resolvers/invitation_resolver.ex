defmodule Newline.InvitationResolver do
  import Newline.BaseResolver

  alias Newline.{InvitationService}

  @doc """
  Create an invitation for the email, on an organization by the current user
  """
  def create(%{email: email}, %{context: %{current_user: user}}) do
    org_id = user.current_organization_id
    InvitationService.invite_user_by_email_to_organization(email, user, org_id)
  end
  def create(_, _) do
    IO.inspect "HUH?"
    Newline.BaseResolver.unauthorized_error
  end
end