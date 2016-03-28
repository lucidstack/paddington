defmodule Paddington.Emitter do
  def start_link(device_name) do
    GenServer.start_link(__MODULE__, device_name, name: __MODULE__)
  end

  # Client implementation
  #######################

  def emit(event), do:
    GenServer.cast(__MODULE__, {:emit, event})

  # Server implementation
  #######################

  def init(device_name), do:
    PortMidi.open(:output, device_name)

  def handle_cast({:emit, event}, output) do
    PortMidi.write(output, event)
    {:noreply, output}
  end
end
