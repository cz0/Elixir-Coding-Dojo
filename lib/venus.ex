defmodule Venus do
  def get_height(x, y) do
    x + y
  end

  def process_get_height() do
    spawn(fn ->
      loop()
    end
    )
  end

  defp loop() do
    receive do
      {:height, caller, x, y} ->
        send(caller, get_height(x, y))
    end
    loop()
  end
end
