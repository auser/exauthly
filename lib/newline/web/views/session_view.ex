defmodule Newline.Web.SessionView do
  use Newline.Web, :view
  # alias Newline.Web.SessionView

  def render("show.json", %{user: user, jwt: jwt}) do
    %{
      data: render_one(user, Newline.Web.UserView, "user.json"),
      meta: %{token: jwt}
    }
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("no_session.json", _) do
    %{errors: "invalid or expired session token"}
  end
end
