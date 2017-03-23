defmodule Goncord.UserTest do
  use Goncord.ModelCase

  alias Goncord.User

  @valid_attrs %{birthday: %{day: 17, month: 4, year: 2010}, email: "some content", first_name: "some content", hashed_password: "some content", last_name: "some content", login: "some content", second_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
