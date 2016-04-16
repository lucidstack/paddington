defmodule Paddington.Apps.Helpers do
  defmacro __using__(_opts) do
    quote do
      use Paddington.Apps.Helpers.General
      use Paddington.Apps.Helpers.OSX
      use Paddington.Apps.Helpers.Tmux
      use Paddington.Apps.Helpers.Mpc
      use Paddington.Apps.Helpers.Led
    end
  end
end
