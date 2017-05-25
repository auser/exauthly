defmodule Newline.Email do
  @moduledoc """
  Handles sending emails

  TODO: i18n
  """
  use Bamboo.Phoenix, view: Newline.EmailView
  # alias Newline.{User}

  def welcome_email(user) do
    from_postmaster(user)
    |> subject("Welcome to Fullstack.io")
    |> render("welcome_email_en.text")
  end
  
  def invitation_email(invitee) do
    from_postmaster(invitee)
    |> subject("You've been invited")
    |> render("invitation_email_en.text")
  end

  def password_reset_request_email(user) do
    from_postmaster(user)
    |> subject("You requested a password reset")
    |> assign(:url, "http://localhost:4000") # TODO: Update
    |> assign(:token, user.password_reset_token)
    |> render("password_reset_request_email_en.text")
  end

  def password_reset_email(user) do
    from_postmaster(user)
    |> subject("Your password was reset")
    |> render("password_reset_email_en.text")
  end

  defp from_postmaster(user) do
    new_email()
    |> from("Fullstack <hello@fullstack.io>")
    |> put_header("Reply-To", "hello@fullstack.io")
    |> to("#{Newline.UserHelpers.full_name(user)} <#{user.email}>")
  end

end