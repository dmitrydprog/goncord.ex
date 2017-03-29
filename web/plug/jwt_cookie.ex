defmodule Goncord.Plug.JwtCookie do
  def init(opts), do: opts

  def call(conn, _opts) do
    conn = Plug.Conn.fetch_cookies(conn)
    jwt_cookie = conn.cookies["jwt"]

    case Plug.Conn.get_req_header(conn, "authorization") do
      [] -> conn
      _  -> Plug.Conn.put_req_header(conn, "authorization", "Bearer #{jwt_cookie}")
    end
  end
end