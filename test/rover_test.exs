defmodule RoverDojoTest do
  use ExUnit.Case

  test "move north" do
    rover = %Rover{x: 0, y: 0, d: :north}
    assert Rover.process(rover, :M) == %Rover{x: 0, y: 1, d: :north}
  end

  test "move twice" do
    rover = %Rover{x: 0, y: 0, d: :north}
    rover = Rover.process(rover, :M)

    assert Rover.process(rover, :M) == %Rover{x: 0, y: 2, d: :north}
  end

  test "turn left" do
    rover = %Rover{x: 0, y: 0, d: :north}
    assert Rover.process(rover, :L) == %Rover{x: 0, y: 0, d: :west}
  end

  test "turn left twice" do
    rover = %Rover{x: 0, y: 0, d: :west}
    rover = Rover.process(rover, :L)
    assert Rover.process(rover, :L) == %Rover{x: 0, y: 0, d: :east}
  end

  test "turn right" do
    rover = %Rover{x: 0, y: 0, d: :north}
    assert Rover.process(rover, :R) == %Rover{x: 0, y: 0, d: :east}
  end

  test "move zig-zag" do
    rover = %Rover{x: 0, y: 0, d: :north}
    |> Rover.process(:L)
    |> Rover.process(:M)
    |> Rover.process(:L)
    |> Rover.process(:M)
    |> Rover.process(:L)
    |> Rover.process(:M)
    |> Rover.process(:L)
    |> Rover.process(:M)

    assert rover == %Rover{x: 0, y: 0, d: :north}
  end

  test "processes array of instructions" do
    rover = %Rover{x: 0, y: 0, d: :north}
    assert Rover.process(rover, [:L, :M, :L, :M, :L, :M, :L, :M]) == %Rover{x: 0, y: 0, d: :north}
  end

  test "process" do
    planet = Venus.process_get_height()
    pid  = Rover.land(planet, 0, 0, :north)
    send(pid, {:L, self()})
    send(pid, {:M, self()})
    receive do
      {:height, x, y, height} ->
        assert x + y == height
    end
  end
end
