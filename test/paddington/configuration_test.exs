defmodule PaddingtonConfigurationTest do
  import Paddington.Configuration

  use ExUnit.Case, async: false
  import Mock

  @yaml_mock %{"device" => "Launchpad Mini", "applications" => ["iTunes", "Finder"]}
  test "load/1 returns {:ok, %Configuration{}} from a YAML configuration file" do
    with_mock YamlElixir, [read_from_file: fn(_path) -> @yaml_mock end] do
      assert {:ok, %Paddington.Configuration{
        device: "Launchpad Mini", applications: ["iTunes", "Finder"]
      }} == load("~/.paddington.yml")

      assert called YamlElixir.read_from_file("~/.paddington.yml")
    end
  end

  @yaml_mock %{"device" => "Launchpad Mini", "appriccatis" => ["iTunes", "Finder"]}
  test "load/1 returns {:error, :applications_not_specified} on malformed YAML" do
    with_mock YamlElixir, [read_from_file: fn(_path) -> @yaml_mock end] do
      assert {:error, :applications_not_specified} == load("~/.paddington.yml")
      assert called YamlElixir.read_from_file("~/.paddington.yml")
    end
  end

  @yaml_mock %{"applications" => ["iTunes", "Finder"]}
  test "load/1 returns {:error, :device_not_specified} on malformed YAML" do
    with_mock YamlElixir, [read_from_file: fn(_path) -> @yaml_mock end] do
      assert {:error, :device_not_specified} == load("~/.paddington.yml")
      assert called YamlElixir.read_from_file("~/.paddington.yml")
    end
  end

  @yaml_mock %{"device" => "Launchpad Mini", "applications" => ["iTunes", "Finder"]}
  test "load!/1 returns a %Configuration{} from a YAML configuration file" do
    with_mock YamlElixir, [read_from_file: fn(_path) -> @yaml_mock end] do
      assert %Paddington.Configuration{
        device: "Launchpad Mini", applications: ["iTunes", "Finder"]
      } == load!("~/.paddington.yml")

      assert called YamlElixir.read_from_file("~/.paddington.yml")
    end
  end

  @yaml_mock %{"device" => "Launchpad Mini"}
  test "load!/1 raises a ConfigurationError on malformed YAML" do
    with_mock YamlElixir, [read_from_file: fn(_path) -> @yaml_mock end] do
      load_config = fn -> load!("~/.paddington.yml") end
      assert_raise  Paddington.ConfigurationError, load_config
    end
  end
end
