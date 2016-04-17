defmodule Paddington.Apps.LineApp do
  alias Paddington.AppRegistry
  use Paddington.Apps.Helpers

  @default_colors [red: :high,  green: :low]
  @pressed_colors [red: :high, green: :high]
  @off_colors     [red: :off,   green: :off]

  def start_link(app_name, index) do
    configuration_path = "~/.paddington/#{app_name}.exs" |> Path.expand
    GenServer.start_link(__MODULE__, {configuration_path, index})
  end

  # Public implementation
  #######################
  def new_event(app, event), do: GenServer.cast(app, {:new_event, event})

  # GenServer implementation
  ##########################
  def init({configuration_path, index}) do
    :ok = load_configuration(configuration_path)
    AppRegistry.register(self)

    {:ok, %{index: index, commands: [], app_name: nil, app_type: nil}}
  end

  def handle_cast({:app, name, type}, state) do
    state
    |> Map.put(:app_name, name)
    |> Map.put(:app_type, type)
    |> with_noreply
  end

  def handle_cast({:command, label, block}, %{commands: commands} = state) do
    set_light(state.index, length(commands), @default_colors)

    state
    |> Map.put(:commands, [{label, block} | commands])
    |> with_noreply
  end

  def handle_cast({:new_event, {:grid, x, y, :pressed}}, state) do
    set_light(x, y, @pressed_colors)
    {:noreply, state}
  end

  def handle_cast({:new_event, {:grid, x, y, :released}}, %{index: i, commands: c} = state)
  when i == x and y < length(c) do
    set_light(x, y, @default_colors)

    {label, block} = state.commands |> Enum.reverse |> Enum.at(y)
    Code.eval_quoted(block, [x: x, y: y, state: state], __ENV__)

    {:noreply, state}
  end

  # Fallback = Ignore
  ###################
  def handle_cast({:new_event, _event}, state) do
    {:noreply, state}
  end

  # Private implementation
  ########################
  defp load_configuration(path) do
    if File.exists?(path) do
      path |> File.read! |> Code.eval_string(
        [],
        functions: [{__MODULE__, __info__(:functions)}],
        macros:    [{__MODULE__, __info__(:macros)}]
      )

      :ok
    else
      {:error, :configuration_not_found}
    end
  end
end
