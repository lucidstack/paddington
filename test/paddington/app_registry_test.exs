defmodule PaddingtonAppRegistryTest do
  import Paddington.AppRegistry
  use ExUnit.Case, async: true

  test "init/1 initializes the state with an empy registry" do
    assert {:ok, []} == init(:ok)
  end

  test "register/1 adds given app to the registry" do
    app = Agent.start(fn -> 0 end)
    assert {:noreply, [app]} == handle_cast({:register, app}, [])
  end

  test "broadcast/1 sends the given event to the apps in state" do
    handle_cast({:broadcast, :test}, [self])
    assert_received :test
  end
end
