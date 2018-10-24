defmodule Rover do
  defstruct x: nil, y: nil, d: nil

  def process(%Rover{d: :north, y: y} = rover, :M), do: %Rover{rover | y: y + 1}

  def process(%Rover{d: :east, x: x} = rover, :M), do: %Rover{rover | x: x + 1 }

  def process(%Rover{d: :south, y: y} = rover, :M), do: %Rover{rover | y: y - 1 }

  def process(%Rover{d: :west, x: x} = rover, :M), do: %Rover{rover | x: x - 1}


  def process(%Rover{d: :north} = rover, :L), do: %Rover{rover | d: :west}

  def process(%Rover{d: :east} = rover, :L), do: %Rover{rover | d: :north}

  def process(%Rover{d: :south} = rover, :L), do: %Rover{rover | d: :east}

  def process(%Rover{d: :west} = rover, :L), do: %Rover{rover | d: :south}

  def process(rover, :R) do
    rover
    |> process(:L)
    |> process(:L)
    |> process(:L)
  end

  def process(rover, []) do
    rover
  end

  def process(rover, [head | tail]) do
    process(process(rover, head), tail)
  end

  def land(planet, x, y, d) do
    spawn(fn ->
      loop(planet, %Rover{x: x, y: y, d: d})
    end
    )
  end

  defp loop(planet, rover) do
    receive do
      {:M, caller} ->
        rover = rover.process(:M)
        send(planet, {self(), rover.x, rover.y})
        receive do
          h ->
            send(caller, {:height, rover.x, rover.y, h})
        end
        loop(planet, rover)
      {i, caller} ->
        rover = rover.process(i)
        loop(planet, rover)
    end
  end
end
