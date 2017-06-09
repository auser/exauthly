defmodule Newline.Validators.EmailValidator do
  @moduledoc false

  @email_regexp ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  def parse_and_validate_is_email(email) do
    case Regex.match?(@email_regexp, email) do
      false -> :error
      true -> {:ok, email}
    end
  end

end
