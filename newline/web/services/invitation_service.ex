defmodule Newline.InvitationService do
  @moduledoc """
    Business logic of invitations
  """  
  alias Newline.{Invitation, Mailer, Organization, User, Repo, Email}
  use Newline.Web, :service

  @doc """
    Create a user
    Create the invitation
    Send an email
  """
  def invite_user_by_email_to_organization(email, %User{} = user, %Organization{} = org) do
    case Repo.transaction(insert_invitation(email, user, org)) do
      {:ok, %{invitation: invitation}} ->
        {:ok, invitation}
      {:error, _failed_op, changeset, _changes} ->
        {:error, changeset}
    end
  end

  defp insert_invitation(email, user, org) do
    Multi.new
    |> Multi.insert(:create_invitee, invitee_changeset(email))
    |> Multi.run(:invitation, &(create_invitation_changeset(&1[:create_invitee], user, org)))
    |> Multi.run(:send_invite_email, &(send_invite_email(%{}, &1[:create_invitee])))
  end

  def invitee_changeset(email) do
    User.changeset(%User{}, %{email: email})
  end

  def create_invitation_changeset(invitee, user, org) do
    Invitation.create_changeset(%Invitation{}, %{organization: org, user: user, invitee: invitee})
    |> Repo.insert
  end

  def send_invite_email(_params, invitee) do
    invitee
    |> Email.invitation_email
    |> Mailer.deliver_later
    {:ok, invitee}
  end
end