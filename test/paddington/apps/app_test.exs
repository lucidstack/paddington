defmodule PaddingtonAppsAppTest do
  use ExUnit.Case, async: false
  import Mock

  import Paddington.Apps.App

  @yaml_mock %{"commands" => ["ln -s"]}
  test "start_link/2, given an app name and an index, stores the commands" do
    with_mock YamlElixir, [read_from_file: fn(_path) -> @yaml_mock end] do
      {:ok, app} = start_link("iTunes", 0)
      assert ["ln -s"] == commands(app)
    end
  end

  test "new_event/2, given an event, make a system call to the command" do
    handle_cast({:new_event, {:grid, 0, 0, :released}}, {0, ["ln -s", "cat /dev/null"]})
    assert called :os.cmd("ln -s")
  end
end
