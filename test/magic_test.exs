defmodule MagicTest do
  use ExUnit.Case
  import Magic
  doctest Magic

  defp_protected oops!, do: raise ArgumentError, "oops!"

  test "sigil_x" do
    assert {:ok, ["123"]} = ~x{echo 123}s
  end

  test "sigil_x with escape" do
    a = 123
    assert {:ok, ["123"]} = ~x{echo #{a}}s
  end

  test "sigil_q with error" do
    assert {:error, _} = ~q{echoa}s
  end

  test "sigil_q without error" do
    assert {:ok, ["123"]} = ~q{echo 123}s
  end

  test "defp_protected" do
    assert oops!() == {:error, %ArgumentError{message: "oops!"}}
  end

  test "sigil_b" do
    ~b(echo 123)
    assert_receive {_, {:data, "123\n"}}
    assert_receive {_, {:exit_status, 0}}
  end
end
