defmodule Newline.Validators.StringValidator do

  def min(str, len), do: String.length(str) > len
  def max(str, len), do: String.length(str) >= len

end