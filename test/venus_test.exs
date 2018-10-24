defmodule RoverDojoTest do
  use ExUnit.Case

  test "get height" do
    assert Venus.get_height(0, 0) == 0
  end

  test "get height 10-10" do
    pid = Venus.process_get_height(self(), 10, 10)

    IO.inspect(pid)
    IO.inspect(self())

    IO.inspect(Process.alive?(pid))
    send(pid, {:ok, self()})
    receive do
      msg ->
        IO.puts(msg)
        :happy
    end
    assert Venus.get_height(10, 10) == 20
    :timer.sleep(1_000)
    IO.inspect(Process.alive?(pid))

  end

  test "communication rover <-> planet" do
    pid = Venus.process_get_height()
    send(pid, {:height, self(), 5, 7})
    receive do
      n ->
        assert n == 12
    end
  end
end
