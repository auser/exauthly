defmodule Newline.Web.SharedView do
  use Newline.Web, :view

  def navbar do
    render("navbar.html", assigns: %{nav: "Ari"})
  end
end
