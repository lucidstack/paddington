defmodule Paddington.Apps.Helpers.Led do
  alias Paddington.Midi.Emitter

  defmacro __using__(_opts) do
    quote do
      import Paddington.Apps.Helpers.Led
    end
  end

  defmacro led, do: __MODULE__
  defmacro green do
    quote do
      set_light(var!(x), var!(y), green: :high)
    end
  end

  def set_light(x, y, colors) do
    :grid
    |> get_transducer.to_midi(pos: {x, y}, colors: colors)
    |> Emitter.emit
  end

  # Private implementation
  ########################
  defp get_transducer do
    Application.get_env(:paddington, :transducer)
  end
end
