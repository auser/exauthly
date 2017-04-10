defmodule Newline.Email do
  use Bamboo.Phoenix, view: Newline.EmailView
  alias Newline.{User}

  def welcome_email(user) do
    from_postmaster()
    |> to("#{Newline.UserHelpers.full_name(user)} <#{user.email}>")
    |> subject("Welcome to Fullstack.io")
    |> render("welcome_email_en.text")
  end

  defp from_postmaster do
    new_email
    |> from("Fullstack <hello@fullstack.io>")
    |> put_header("Reply-To", "hello@fullstack.io")
  end

end