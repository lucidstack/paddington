defmodule Paddington.Apps.Helpers.General do
  defmacro __using__(_opts) do
    quote do
      import Paddington.Apps.Helpers.General
      general_app
    end
  end

  defmacro general_app do
    quote do
      # Configuration helpers
      #######################
      def app(name, type, pid), do: GenServer.cast(pid,  {:app, name, type})
      def app(name, type),      do: GenServer.cast(self, {:app, name, type})
      defmacro command(label, do: block) do
        GenServer.cast(self, {:command, label, block})
      end

      # Server helpers
      ################
      defp with_noreply(state), do: {:noreply, state}
    end
  end

  def open(uri) do
    case :os.type do
      {:unix, :darwin} -> cmd("open #{uri}")
      {:unix, _}       -> cmd("xdg-open #{uri}")
    end
  end

  def cmd(comm) do
    comm
    |> to_char_list
    |> :os.cmd
    |> to_string
    |> String.replace_suffix("\n", "")
  end
end
