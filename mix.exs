defmodule Paddington.Mixfile do
  use Mix.Project

  def project do
    [app: :paddington,
     version: "1.0.3",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :portmidi, :yaml_elixir],
     mod: {Paddington, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:portmidi, github: "lucidstack/ex-portmidi"},
     {:mock, "~> 0.1.1", only: :test},
     {:credo, "~> 0.3.10", only: [:dev, :test]},
     {:yamerl, github: "yakaz/yamerl"},
     {:yaml_elixir, "~> 1.2.0"}]
  end
end
