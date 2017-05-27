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
  def invite_user_by_email_to_organization(email, %User{} = user, org_id) when is_number(org_id) do
    org = Repo.get(Organization, org_id)
    invite_user_by_email_to_organization(email, user, org)
  end
  def invite_user_by_email_to_organization(email, %User{} = user, %Organization{} = org) do
    multi = case Repo.get_by(User, %{email: email}) do
      nil -> create_invitation_with_new_user(email, user, org)
      %User{} = invitee -> create_invitation_with_existing_user(invitee, user, org)
    end
    case Repo.transaction(multi) do
      {:ok, %{invitation: invitation}} ->
        {:ok, invitation}
      {:error, _failed_op, changeset, _changes} ->
        {:error, changeset}
    end
  end

  defp create_invitation_with_existing_user(invitee, user, org) do
    Multi.new
    |> Multi.run(:create_invitee, fn (_) -> {:ok, invitee} end)
    |> insert_invitation(user, org)
  end

  defp create_invitation_with_new_user(email, user, org) do
    Multi.new
    |> Multi.insert(:create_invitee, invitee_changeset(email))
    |> insert_invitation(user, org)
  end

  defp insert_invitation(multi, user, org) do
    multi
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