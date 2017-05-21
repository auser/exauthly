defmodule Newline.UserHelpers do
  @moduledoc false
  alias Newline.User

  def full_name(%User{name: name}) do
    name
  end

end
