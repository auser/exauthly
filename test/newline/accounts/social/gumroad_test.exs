defmodule Newline.Accounts.Social.GumroadTest do
  use Newline.DataCase
  # alias Newline.Repo
  # alias Ecto.{Changeset}
  # import Newline.Factory
  alias Newline.Accounts.Social.Gumroad

  describe "authorize_url!/1" do
    test "has the right url" do
      url = Gumroad.authorize_url!
      assert Regex.run(~r{client_id=(.*)}, url)
    end
  end

end
