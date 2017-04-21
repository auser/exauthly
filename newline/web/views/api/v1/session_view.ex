defmodule Newline.SessionView do

  use Newline.Web, :view

  def render("show.json", %{user_id: user_id, token: token}) do
    %{token: token, user_id: user_id}
  end

  def render("401.json", %{message: message}) do
    %{
      errors: [
        %{
          id: "unauthorized",
          title: "401 Unauthorized",
          detail: message,
          status: 401
        }
      ]
    }
  end

end