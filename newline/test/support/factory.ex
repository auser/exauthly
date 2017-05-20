defmodule Newline.Factory do
  use ExMachina.Ecto, repo: Newline.Repo
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  @pass "Something"
  @encrypted_password hashpwsalt(@pass)

  def user_factory do
    %Newline.User{
      name: "Ari Lerner",
      email: sequence(:email, &"email-#{&1}@fullstack.io"),
      password: @pass,
      encrypted_password: @encrypted_password
    }
  end

  def set_password(user, password) do
    hashed_password = hashpwsalt(password)
    %{user | encrypted_password: hashed_password}
  end

  def organization_factory do
    %Newline.Organization{
      name: sequence(:name, &"fullstack-#{&1}")
    }
  end

  def organization_membership_factory do
    %Newline.OrganizationMembership{
      member: build(:user),
      organization: build(:organization),
      role: "owner"
    }
  end

end