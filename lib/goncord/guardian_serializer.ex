defmodule Goncord.GuardianSerializer do
  @moduledoc false
  @behaviour Guardian.Serializer

  alias Goncord.Repo
  alias Goncord.User

  def for_token(user = %User{}), do: { :ok, "User:#{user.id}" }

  def for_token(_), do: { :error, "Неизвестный ресурс" }

  def from_token("User:" <> id) do
    user = Repo.get(User, id)
        |> Repo.preload(:roles)
        |> Repo.preload(:resources)

    {:ok, user}
  end

  def from_token(_), do: { :error, "Неизвестный ресурс" }
end