defmodule Newline.Validators.PasswordValidator do
  @moduledoc false

  import Newline.Validators.StringValidator

  def parse(password) when byte_size(password) > 4, do: {:ok, password}
  def parse(password), do: :error

end
