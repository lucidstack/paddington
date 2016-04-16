defmodule Paddington.Apps.Helpers.Tmux do
  import Paddington.Apps.Helpers.General

  defmacro __using__(_opts) do
    quote do
      import Paddington.Apps.Helpers.Tmux
    end
  end

  def tmux, do: __MODULE__
  def tmux(command), do: cmd("tmux #{command}")

  def current_session do
    tmux("display-message -p '#S'")
  end

  def switch,          do: tmux("switch-client")
  def switch(session), do: tmux("switch-client -t #{session}")
end
