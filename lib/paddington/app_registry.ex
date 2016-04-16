defmodule Paddington.AppRegistry do
  alias Paddington.Apps.LineApp

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Client implementation
  #######################

  def register(app), do:
    GenServer.cast(__MODULE__, {:register, app})

  def broadcast(event), do:
    GenServer.cast(__MODULE__, {:broadcast, event})

  # Server implementation
  #######################

  def init(:ok), do:
    {:ok, []}

  def handle_cast({:register, app}, apps), do:
    {:noreply, [app | apps]}

  def handle_cast({:broadcast, event}, apps) do
    apps |> Enum.each(&LineApp.new_event(&1, event))
    {:noreply, apps}
  end
end
