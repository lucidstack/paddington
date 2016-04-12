defmodule PaddingtonTransducersLaunchpadTransducerTest do
  use ExUnit.Case, async: true

  alias  Paddington.Transducers.LaunchpadTransducer.OutOfBoundsCoordsError
  import Paddington.Transducers.LaunchpadTransducer

  test "to_coord/1, given a grid event, returns coordinate tuple" do
    assert to_coord({144, 0, 127}) == {:grid, 0, 0, :pressed}
    assert to_coord({144, 0, 0}) == {:grid, 0, 0, :released}
  end

  test "to_coord/1, given a :top event, returns index of top button" do
    assert to_coord({176, 104, 127}) == {:top, 0, :pressed}
    assert to_coord({176, 107, 0}) == {:top, 3, :released}
  end

  test "to_coord/1, given a :right event, returns index of right button" do
    assert to_coord({144, 8, 127}) == {:right, 0, :pressed}
    assert to_coord({144, 56, 0}) == {:right, 3, :released}
  end

  test "to_midi/1, given a grid event, returns a MIDI tuple" do
    assert to_midi(
      :grid, pos: {0, 0}, colors: [red: :off, green: :high]
    ) == {144, 0, 60}
  end

  test "to_midi/1, given no colors, turns off the cell" do
    assert to_midi(
      :grid, pos: {0, 0}, colors: []
    ) == {144, 0, 12}
  end

  test "to_midi/1, given out of bounds coords, raises an exception" do
    assert_raise OutOfBoundsCoordsError, fn ->
      to_midi(:grid, pos: {0, 9}, colors: [])
    end
  end
end

