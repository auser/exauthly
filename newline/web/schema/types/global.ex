defmodule Newline.Schema.Types.Global do
  use Absinthe.Schema.Notation

  scalar :email do
    name "Email"
    description "User's Email"
    serialize fn(x) -> x end
    parse &Newline.Validators.EmailValidator.parse_and_validate_is_email(&1.value)
  end

  scalar :password do
    name "Password"
    description "Password"
    serialize fn(x) -> x end
    parse &Newline.Validators.PasswordValidator.parse(&1.value)
  end
end