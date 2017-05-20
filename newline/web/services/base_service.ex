defmodule Newline.BaseService do
  @unauthorized_error {:error, "Unauthorized"}
  @unauthenticated_error {:error, "User not logged in"}

  def unauthenticated_error, do: @unauthenticated_error
  def unauthorized_error, do: @unauthorized_error
end