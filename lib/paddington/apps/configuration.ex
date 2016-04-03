defmodule Paddington.Apps.Configuration do
  import YamlElixir, only: [read_from_file: 1]
  alias Paddington.ConfigurationError
  defstruct [:commands]

  @doc """
    Opens and parses the given path with YamlElixir. A struct
    `%Paddington.Apps.Configuration{}` is returned with `:ok`, or `{:error, reason}`
    if there are problem with the given configuration file.
  """
  @spec load(String.t()) :: {:ok, %Paddington.Configuration{}} | {:error, atom}
  def load(app_name) do
    app_name
    |> make_config_path
    |> read_from_file
    |> atomize_keys
    |> turn_into_struct
    |> check
  end

  @doc """
    Same as `load/1`, but directly returns the `%Paddington.Apps.Configuration{}` struct.
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

  defp check(%{commands: nil}),                  do: {:error, :commands_not_specified}
  defp check(%{commands: c}) when length(c) > 8, do: {:error, :too_many_commands}
  defp check(configuration),                     do: {:ok, configuration}

  defp atomize_keys(yaml), do:
    for {k, v} <- yaml, into: %{}, do: {String.to_atom(k), v}

  defp turn_into_struct(yaml), do:
    struct(__MODULE__, yaml)

  defp make_config_path(app_name), do:
    "~/.paddington/#{app_name}.yml" |> Path.expand
end

