defmodule MagicTest do
  use ExUnit.Case
  import Magic
  doctest Magic

  test "test sigil_x" do
    assert {:ok, ["123"]} = ~x{echo 123}s
  end

  test "test sigil_x with escape" do
    a = 123
    assert {:ok, ["123"]} = ~x{echo #{a}}s
  end

  test "test sigil_q with error" do
    assert {:error, _} = ~q{echoa}s
  end

  test "test sigil_q without error" do
    assert {:ok, ["123"]} = ~q{echo 123}s
  end
end
