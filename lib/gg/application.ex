defmodule GG.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: GG.Worker.start_link(arg)
      # {GG.Worker, arg}
      GG.Consumer,
      GG.Actors.CreepyMessage,
      GG.Actors.Apollonius,
      GG.Actors.Sevro,
      GG.Actors.Ephraim,
      GG.Actors.Mustang
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GG.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
