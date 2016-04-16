defmodule Paddington.Apps.Helpers.Mpc do
  import Paddington.Apps.Helpers.General

  defmacro __using__(_opts) do
    quote do
      import Paddington.Apps.Helpers.Mpc
    end
  end

  def mpc, do: __MODULE__
  def mpc(command), do: cmd("mpc #{command}")

  def previous,  do: mpc("prev")
  def playpause, do: mpc("toggle")
  def next,      do: mpc("next")

  def is_playing? do
    Regex.match?(~r(\[playing\]), mpc("status"))
  end
end

