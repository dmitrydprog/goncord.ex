defmodule Goncord.Plug.ResourceToken do
  import Ecto.Query

  def init(opts), do: opts

  def call(conn, _opts) do
    case Plug.Conn.get_req_header(conn, "x-app-token") do
      [app_token] ->
        query = from res in Goncord.Resource,
                where: ^app_token == res.token
        resource = Goncord.Repo.one(query)

        Plug.Conn.assign(conn, :resource, resource)

      _ -> conn
    end
  end
end