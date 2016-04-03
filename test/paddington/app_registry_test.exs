defmodule PaddingtonAppRegistryTest do
  use ExUnit.Case, async: false
  import Mock

  alias  Paddington.Apps.App
  import Paddington.AppRegistry

  test "init/1 initializes the state with an empy registry" do
    assert {:ok, []} == init(:ok)
  end

  test "register/1 adds given app to the registry" do
    app = Agent.start(fn -> 0 end)
    assert {:noreply, [app]} == handle_cast({:register, app}, [])
  end

  test "broadcast/1 sends the given event to the apps in state" do
    with_mock App, [new_event: fn(_app, _event) -> :ok end] do
      handle_cast({:broadcast, :test}, [self])
      assert called App.new_event(self, :test)
    end
  end
end
