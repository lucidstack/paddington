defmodule Paddington.ConfigurationError, do: defexception [:message]

defmodule Paddington.Configuration do
  import YamlElixir, only: [read_from_file: 1]
  alias Paddington.ConfigurationError
  defstruct [:device, :applications]

  @doc """
    Opens and parses the given path with YamlElixir. A struct
    `%Paddington.Configuration{}` is returned with `:ok`, or `{:error, reason}`
    if there are problem with the given configuration file.
  """
  @spec load(String.t()) :: {:ok, %Paddington.Configuration{}} | {:error, atom}
  def load(config_path) do
    config_path
    |> read_from_file
    |> atomize_keys
    |> turn_into_struct
    |> check
  end

  @doc """
    Same as `load/1`, but directly returns the `%Paddington.Configuration{}` struct.
    If problems are found in the configuration file, raises a `Paddington.ConfigurationError`.
  """
  @spec load!(String.t()) :: %Paddington.Configuration{}
  def load!(config_path) do
    case config_path |> load do
      {:ok, configuration} -> configuration
      {:error, reason}     -> raise ConfigurationError, message: to_string(reason)
    end
  end

  # Private implementation
  ########################

  defp check(%{device: nil}), do:       {:error, :device_not_specified}
  defp check(%{applications: nil}), do: {:error, :applications_not_specified}
  defp check(configuration), do:        {:ok, configuration}

  defp atomize_keys(yaml), do:
    for {k, v} <- yaml, into: %{}, do: {String.to_atom(k), v}

  defp turn_into_struct(yaml), do:
    struct(__MODULE__, yaml)
end

