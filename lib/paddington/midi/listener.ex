defmodule Paddington.Midi.Listener do
  import Logger
  alias Paddington.AppRegistry

  def start_link(device_name) do
    Task.start_link fn -> listen(device_name) end
  end

  def listen(device_name) do
    case PortMidi.open(:input, device_name) do
      {:ok, input} ->
        PortMidi.listen(input, self)
        loop(input)
      {:error, reason} ->
        error "Device couldn't be opened: #{reason}"
        exit(reason)
    end
  end

  def loop(input) do
    receive do
      {^input, event} -> translate_and_send(event)
    end

    loop(input)
  end

  def translate_and_send(event) do
    event
    |> get_transducer.to_coord
    |> AppRegistry.broadcast
  end

  defp get_transducer, do:
    Application.get_env(:paddington, :transducer)
end
