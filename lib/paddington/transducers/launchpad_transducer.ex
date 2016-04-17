defmodule Paddington.Transducers.LaunchpadTransducer do
  @behaviour Paddington.Transducer

  import Logger, only: [warn: 1]
  defmodule OutOfBoundsCoordsError, do: defexception [:message]
  defmacro in_bounds(coord), do:
    quote do: unquote(coord) >= 0 and unquote(coord) <= 7

  @grid_status  144
  @right_status 144
  @top_status   176
  @reset_status 176

  @top_base_note 104
  @right_notes   [8, 24, 40, 56, 72, 88, 104, 120]

  @base_velocity    12
  @press_velocity   127
  @release_velocity 0
  @reset_velocity   0

  def devices, do:
    ["Launchpad", "Launchpad Mini"]

  # MIDI => Paddington
  ####################

  # Top row
  def to_coord({@top_status, note, @press_velocity}), do:
    {:top, note - @top_base_note, :pressed}
  def to_coord({@top_status, note, @release_velocity}), do:
    {:top, note - @top_base_note, :released}

  # Right column
  def to_coord({@right_status, note, @press_velocity}) when note in @right_notes, do:
    {:right, (note - 8) / 16, :pressed}
  def to_coord({@right_status, note, @release_velocity}) when note in @right_notes, do:
    {:right, (note - 8) / 16, :released}

  # Grid
  def to_coord({@grid_status, note, @press_velocity}), do:
    {:grid, rem(note, 16), trunc(note/16), :pressed}
  def to_coord({@grid_status, note, @release_velocity}), do:
    {:grid, rem(note, 16), trunc(note/16), :released}

  # Fallback
  def to_coord(input), do:
    warn("Can't find a tranducer for MIDI event " <> inspect(input))

  # Paddington => MIDI
  ####################

  def to_midi(:grid, pos: {x, y}, colors: colors) when in_bounds(x) and in_bounds(y), do:
    {@grid_status, to_note(x, y), velocity(colors)}

  def to_midi(:grid, pos: {_x, _y}, colors: _), do:
    raise OutOfBoundsCoordsError, "x and y must be between 0 and 7"

  def to_midi(:reset), do:
    {@reset_status, 0, @reset_velocity}

  # Private implementation
  ########################

  defp to_note(x, y), do: y * 16 + x

  import Keyword, only: [get: 3]
  defp velocity(colors) do
    red   = (colors |> get(:red,   :off) |> brightness)
    green = (colors |> get(:green, :off) |> brightness) * 16
    red + green + @base_velocity
  end

  defp brightness(:off),    do: 0
  defp brightness(:low),    do: 1
  defp brightness(:medium), do: 2
  defp brightness(:high),   do: 3
end

