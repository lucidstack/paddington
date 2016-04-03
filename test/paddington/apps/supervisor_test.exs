defmodule PaddingtonAppsSupervisorTest do
  use ExUnit.Case, async: false
  import Mock

  import Paddington.Apps.Supervisor
  alias  Paddington.Apps.App

  test "init/1, given app names, starts Apps.Application with name" do
    {:ok, mock_app} = Agent.start(fn -> [] end)

    with_mock App, [start_link: fn(_name, _index) -> {:ok, mock_app} end] do
      {:ok, supervisor} = start_link(["iTunes", "Spotify"])

      assert called App.start_link("iTunes", 0)
      assert called App.start_link("Spotify", 1)
      supervisor |> Supervisor.stop
    end
  end
end
