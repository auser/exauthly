defmodule Newline.Email do
  use Bamboo.Mailer, otp_app: :newline
  import Bamboo.Email
  alias Newline.Accounts.User

  @template_dir "#{__DIR__}/templates"

  def send_welcome_email(%User{} = user) do
    user |> build_email("welcome") |> deliver_later()
  end

  def send_password_reset_request_email(%User{} = user) do
    user |> build_email("password_reset_request") |> deliver_later()
  end

  def send_password_reset_email(%User{} = user) do
    user |> build_email("password_reset") |> deliver_later()
  end

  def send_change_password(%User{} = user) do
    build_email(user, "password_changed") |> deliver_later()
  end

  defp build_email(%User{email: to} = user, filename) do
    fields = [to: to,
              from: Application.get_env(:newline, Newline.Email)[:from],
              subject: "Password Reset Request",
              html_body: filename |> body("html", user: user),
              text_body: filename |> body("txt", user: user)]
    new_email(fields)
  end

  defp body(filename, format, fields) do
    "#{@template_dir}/#{filename}.#{format}.eex" |> EEx.eval_file(fields)
  end
end
