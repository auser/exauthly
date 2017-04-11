defmodule Newline.Factory do
  use ExMachina.Ecto, repo: Newline.Repo

  def user_factory do
    %Newline.User{
      first_name: "Ari",
      last_name: "Lerner",
      email: sequence(:email, &"email-#{&1}@fullstack.io"),
      password: "Something"
    }
  end

end