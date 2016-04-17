defmodule Paddington.Apps.Helpers.OSX do
  defmacro __using__(_opts) do
    quote do
      import Paddington.Apps.Helpers.OSX
      osx_app
    end
  end

  defmacro osx_app do
    quote do
      def handle_cast({:osx, name}, state) do
        state
        |> Map.put(:osx_app, name)
        |> with_noreply
      end

      def osx(name), do: GenServer.cast(self, {:osx, name})
    end
  end

  defmacro osascript(command) do
    quote do
      app = case Map.get(var!(state), :osx_app) do
        nil -> Map.get(var!(state), :app_name)
        app -> app
      end

      cmd("""
        osascript -e 'tell application "#{app}"
            #{unquote(command)}
        end tell'
      """)
    end
  end
end
