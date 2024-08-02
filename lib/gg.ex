defmodule GG do
  if Mix.env() == :dev do
    def server_id, do: 1_268_752_081_179_775_108
  else
    def server_id, do: 1_236_337_117_593_075_863
  end
end
