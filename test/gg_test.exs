defmodule GGTest do
  use ExUnit.Case
  doctest GG

  test "greets the world" do
    assert GG.hello() == :world
  end
end
