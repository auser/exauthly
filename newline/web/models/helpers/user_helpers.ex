defmodule Newline.UserHelpers do
  alias Newline.User

  def full_name(%User{name: name}) do
    name
  end

end
