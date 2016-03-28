defmodule Paddington do
  alias Paddington.Listener
  alias Paddington.Emitter

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Listener, ["Launchpad Mini"]),
      worker(Emitter, ["Launchpad Mini"]),
    ]

    opts = [strategy: :one_for_one, name: Paddington.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
