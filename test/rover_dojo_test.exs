defmodule RoverDojoTest do
  use ExUnit.Case
  doctest RoverDojo

  test "greets the world" do
    assert RoverDojo.hello() == :world
  end
end
