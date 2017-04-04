defmodule Goncord.Plug.IsSuperResource do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    resource = conn.assigns[:resource]

    case resource do
      nil       -> conn |> send_resp(403, "Ресурс не найден.")
                        |> halt

      resource  ->
        case resource.is_super do
          true  -> conn
          false -> conn |> send_resp(403, "Недостаточно прав.")
                        |> halt
        end
    end
  end
end