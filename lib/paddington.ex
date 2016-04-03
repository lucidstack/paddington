defmodule Paddington do
  alias Paddington.AppRegistry
  alias Paddington.Emitter
  alias Paddington.Listener

  use Application

  def start(_type, _args) do
    if System.get_env("DEBUG"), do: :observer.start
    import Supervisor.Spec, warn: false

    children = [
      worker(AppRegistry, []),
      worker(Emitter, ["Launchpad Mini"]),
      worker(Listener, ["Launchpad Mini"]),
    ]

    opts = [strategy: :one_for_one, name: Paddington.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
