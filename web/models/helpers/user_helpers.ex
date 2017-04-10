defmodule Newline.UserHelpers do
  alias Newline.User

  def full_name(%User{first_name: first_name, last_name: last_name}) do
    [first_name, last_name]
    |> Enum.reject(&(&1 == ""))
    |> Enum.join(" ")
  end

end
