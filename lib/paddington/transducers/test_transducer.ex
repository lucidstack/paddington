defmodule Paddington.Transducers.TestTransducer do
  @behaviour Paddington.Transducer

  def devices, do: ["Test"]

  # MIDI => Paddington
  ####################
  def to_coord(_input), do: {:test, 0, :test}

  # Paddington => MIDI
  ####################
  def to_midi(_action_type),        do: {0, 0, 0}
  def to_midi(_action_type, _opts), do: {0, 0, 0}
end


