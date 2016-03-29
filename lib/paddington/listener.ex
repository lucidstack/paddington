defmodule Paddington.Listener do
  alias Paddington.AppRegistry
  alias Paddington.Transducer

  def start_link(device_name) do
    Task.start_link fn -> listen(device_name) end
  end

  def listen(device_name) do
    {:ok, input} = PortMidi.open(:input, device_name)
    PortMidi.listen(input, self)

    loop
  end

  def loop do
    receive do
      event -> translate_and_send(event)
    end

    loop
  end

  def translate_and_send(event) do
    event
    |> List.to_tuple
    |> Transducer.to_coord
    |> AppRegistry.broadcast
  end
end
