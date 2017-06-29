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

  test "sigil_b with cd" do
    ~b(. ls)c
    assert_receive {_, {:data, "LICENSE\nREADME.md\n_build\nconfig\ndeps\ndoc\nlib\nmagic.iml\nmix.exs\nmix.lock\ntest\n"}}
    assert_receive {_, {:exit_status, 0}}
  end

  test "sigil_b undenfied cmd" do
    ~b(. abcd)c
    assert_receive {_, {:data, "sh: line 0: exec: abcd: not found\n"}}
    assert_receive {_, {:exit_status, 127}}
  end

  test "sigil_x with unknow mod" do
    assert_raise ArgumentError, "modifier must be one of: c, s", fn ->
      ~x(echo 123)d
    end
  end
end
