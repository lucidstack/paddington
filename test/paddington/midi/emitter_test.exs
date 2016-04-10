defmodule PaddingtonMidiEmitterTest do
  use ExUnit.Case, async: false
  import Mock

  import Paddington.Midi.Emitter

  test "init/1, given a device_name, opens an output device and saves it in the state" do
    with_mock PortMidi, [open: fn(:output, "Launchpad") -> {:ok, 123} end] do
      assert {:ok, 123} == init("Launchpad")
    end
  end

  test "emit/1, given an event, writes to the device saved in the state" do
    device = Agent.start(fn -> 0 end)

    with_mock PortMidi, [write: fn(_device, _event) -> :ok end] do
      handle_cast({:emit, {1,2,3}}, device)
      assert called PortMidi.write(device, {1,2,3})
    end
  end
end
