defmodule RandomTest do
  use ExUnit.Case
  import Random
  doctest Random, except: [random: 0]

  test "test random" do
    assert String.length(random()) == 16
  end

  test "test random specific size" do
    assert String.length(random(23)) == 23
  end

  test "test random result's randomness'" do
    data = Enum.reduce(1..1000, %{} ,fn(_, acc) ->
      Map.put(acc, random(), :a)
    end)
    assert data|> Map.keys |> Enum.count == 1000
  end
end
