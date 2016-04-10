defmodule Paddington.Apps.App do
  alias Paddington.Apps.Configuration
  alias Paddington.AppRegistry
  alias Paddington.Midi.Emitter
  alias Paddington.Transducer
  require Logger

  @default_colors [red: :medium, green: :high]
  @pressed_colors [red: :high,   green: :high]
  @off_colors     [red: :off,     green: :off]

  def start_link(app_name, app_index) do
    GenServer.start_link(__MODULE__, {app_name, app_index})
  end

  # Client implementation
  #######################

  def commands(app),         do: GenServer.call(app, :commands)
  def new_event(app, event), do: GenServer.cast(app, {:new_event, event})


  # Server implementation
  #######################

  def init({app_name, app_index}) do
    Process.flag(:trap_exit, true)

    configuration = Configuration.load!(app_name)
    AppRegistry.register(self)

    lights_on(configuration.commands, app_index)
    {:ok, {app_index, configuration.commands}}
  end

  def handle_call(:commands, _from, {app_index, commands}), do:
    {:reply, commands, commands}

  def handle_cast({:new_event, {:grid, x, y, :pressed}}, {app_index, commands})
  when x == app_index and y < length(commands) do
    set_light(app_index, y, @pressed_colors)
    {:noreply, {app_index, commands}}
  end

  def handle_cast({:new_event, {:grid, x, y, :released}}, {app_index, commands})
  when x == app_index and y < length(commands) do
    commands |> Enum.at(y) |> system_call

    set_light(app_index, y, @default_colors)
    {:noreply, {app_index, commands}}
  end


  # Fallback = ignore
  def handle_cast({:new_event, _event}, state), do:
    {:noreply, state}

  def terminate(reason, {commands, app_index}), do:
    lights_off(commands, app_index)

  # Private implementation
  ########################

  defp system_call(%{"command" => com, "args" => args}), do:
    :os.cmd("#{com} #{args}" |> to_char_list)

  defp lights_on(commands, app_index) do
    0..length(commands) - 1 |> Enum.each(fn(com_index) ->
      set_light(app_index, com_index, @default_colors)
    end)
  end

  defp lights_off(commands, app_index) do
    0..length(commands) - 1 |> Enum.each(fn(com_index) ->
      set_light(app_index, com_index, @off_colors)
    end)
  end

  defp set_light(x, y, colors), do:
    :grid
    |> Transducer.to_midi(pos: {x, y}, colors: colors)
    |> Emitter.emit
end
