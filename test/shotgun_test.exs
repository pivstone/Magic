defmodule ShotgunTest do
  use ExUnit.Case
  doctest Shotgun

  test "find twice" do
    assert Shotgun.find(Inspect) == []
    first = System.monotonic_time()
    assert Shotgun.find(Mix.SCM) == [Hex.SCM, Mix.SCM.Path, Mix.SCM.Git]
    second = System.monotonic_time()
    assert Shotgun.find(Mix.SCM) == [Hex.SCM, Mix.SCM.Path, Mix.SCM.Git]
    third = System.monotonic_time()
    assert third - second < second - first
  end
end
