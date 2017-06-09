defmodule Newline.Web.UserView do
  use Newline.Web, :view
  # alias Newline.Web.UserView

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
    }
  end
end
