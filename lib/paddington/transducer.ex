defmodule Paddington.Transducer do
  @transducers_folder __DIR__ <> "/transducers/"

  # Typespecs implementation
  ##########################
  @type t :: module

  @type status   :: non_neg_integer
  @type note     :: non_neg_integer
  @type velocity :: non_neg_integer

  @type action_type :: atom
  @type coordinate  :: integer | {integer, integer}
  @type state       :: atom

  @type opts :: Keyword.t
  @type device_name :: String.t

  # Behaviour implementation
  ##########################
  @callback to_coord({status, note, velocity}) :: {action_type, coordinate, state}
  @callback to_midi(action_type) :: {status, note, velocity}
  @callback to_midi(action_type, opts) :: {status, note, velocity}
  @callback devices() :: [device_name]

  # Public implementation
  #######################
  def set_transducer(device_name) do
    File.ls!(@transducers_folder)
    |> Enum.map(&get_module/1)
    |> Enum.find(&serves_device?(&1, device_name))
    |> do_set_transducer
  end

  # Private implementation
  ########################
  defp get_module(file) do
    file |> Code.load_file(@transducers_folder) |> do_get_module
  end

  defp do_get_module(loading_result) do
    loading_result |> List.last |> elem(0)
  end

  defp serves_device?(module, device_name) do
    module.devices |> Enum.any?( &(&1 == device_name) )
  end

  defp do_set_transducer(nil), do: {:error, :transducer_not_found}
  defp do_set_transducer(module) do
    Application.put_env(:paddington, :transducer, module)
    {:ok, module}
  end
end
