defmodule Newline.Validators.PasswordValidator do

  # import Newline.Validators.StringValidator, only: [min: 2, max: 2]

  def parse(password) do
    case String.length(password) > 4 do
      true -> {:ok, password}
      _ -> :error
    end
  end

end
