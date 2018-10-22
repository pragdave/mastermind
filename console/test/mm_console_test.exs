defmodule MmConsoleTest do
  use ExUnit.Case
  doctest MmConsole

  test "greets the world" do
    assert MmConsole.hello() == :world
  end
end
