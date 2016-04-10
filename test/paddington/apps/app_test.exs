defmodule PaddingtonAppsAppTest do
  use ExUnit.Case, async: false
  import Mock

  import Paddington.Apps.App

  @yaml_mock %{"commands" => [%{"command" => "ln -s", "args" => ""}]}
  test "start_link/2, given an app name and an index, stores the commands" do
    with_mock YamlElixir, [read_from_file: fn(_path) -> @yaml_mock end] do
      {:ok, app} = start_link("iTunes", 0)
      assert [%{"command" => "ln -s", "args" => ""}] == commands(app)
    end
  end
end
