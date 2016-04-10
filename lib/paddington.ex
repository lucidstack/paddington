defmodule Paddington do
  alias Paddington.Apps.Supervisor, as: AppsSupervisor
  alias Paddington.AppRegistry
  alias Paddington.Configuration
  alias Paddington.Midi.Emitter
  alias Paddington.Midi.Listener

  use Application

  def start(_type, _args) do
    if System.get_env("DEBUG"), do: :observer.start

    configuration = "~/.paddington.yml"
    |> Path.expand
    |> Configuration.load!

    start_application(configuration)
  end

  # Private implementation
  ########################

  defp start_application(configuration) do
    import Supervisor.Spec, warn: false

    children = [
      # MIDI interfaces
      worker(Emitter,             [configuration.device]),
      worker(Listener,            [configuration.device]),

      # apps
      worker(AppRegistry,         []),
      supervisor(AppsSupervisor, [configuration.applications]),
    ]

    opts = [strategy: :one_for_one, name: Paddington.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
