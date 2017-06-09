defmodule Newline.Factory do
  use ExMachina.Ecto, repo: Newline.Repo
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  @pass "testing"
  @encrypted_password hashpwsalt(@pass)

  def user_factory do
    %Newline.Accounts.User{
      name: "Ari Lerner",
      email: sequence(:email, &"email-#{&1}@fullstack.io"),
      password: @pass,
      encrypted_password: @encrypted_password,
      verify_token: "verify_token"
    }
  end

  def social_account_factory do
    %Newline.Accounts.SocialAccount{
      social_account_name: "Github",
      social_account_id: "some_github_id",
      auth_token: sequence(:token, &"SomeAuthToken-#{&1}"),
      first_name: "Ari",
      last_name: "Lerner",
      user: build(:user)
    }
  end

  def organization_factory do
    %Newline.Accounts.Organization{
      name: "some name",
      slug: "some-name"
    }
  end

  def organization_membership_factory do
    %Newline.Accounts.OrganizationMembership{
      member_id: build(:user),
      organization_id: build(:organization),
      role: "member"
    }
  end


  def set_password(user, password) do
    hashed_password = hashpwsalt(password)
    %{user | encrypted_password: hashed_password}
  end

end
