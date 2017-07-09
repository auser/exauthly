defmodule Newline.EmailTest do
  use ExUnit.Case, async: true
  use Bamboo.Test

  import Newline.Email
  import Newline.Factory

  test "password_reset_request/1" do
    user = build(:user)
    email = send_password_reset_request_email(user)
    assert email.from == {nil, "postmaster@newline.co"}
    assert email.html_body =~ "You recently requested a password reset"
  end
end
