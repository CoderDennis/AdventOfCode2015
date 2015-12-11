defmodule Day6 do
  def setup_lights(instructions) do
    lights = for x <- 0..999, y <- 0..999, into: %{}, do: {{x,y}, create_light}
    instructions
    |> Enum.map(&parse_instruction/1)
    |> Enum.each(&(do_instruction(&1, lights)))

    Enum.count(lights, fn {_, l} -> GenServer.call(l, :on?) end)
  end

  def create_light() do
    {:ok, pid} = Day6.Light.start_link
    pid
  end

  def parse_instruction(instruction_string) do
    parsed = Regex.named_captures(~r/(?<action>turn off|toggle|turn on) (?<x1>\d+),(?<y1>\d+) through (?<x2>\d+),(?<y2>\d+)/, instruction_string)
    %{action: String.to_atom(parsed["action"]),
      x1: String.to_integer(parsed["x1"]),
      y1: String.to_integer(parsed["y1"]),
      x2: String.to_integer(parsed["x2"]),
      y2: String.to_integer(parsed["y2"])}
  end

  def do_instruction(instruction, lights) do
    (for x <- instruction[:x1]..instruction[:x2],
         y <- instruction[:y1]..instruction[:y2],
        do: {x,y})
    |> Enum.each(&(GenServer.cast(lights[&1], instruction[:action])))
  end
end

# iex.bat --erl "+P 1001000"
# File.stream!("input.txt", [:read, :utf8]) |> Day6.setup_lights

defmodule Day6.Light do
  use GenServer

  ## Client API

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, false}
  end

  def handle_call(:on?, _from, state), do: {:reply, state, state}

  def handle_cast(:"turn on", _state), do: {:noreply, true}
  def handle_cast(:toggle, state), do: {:noreply, !state}
  def handle_cast(:"turn off", _state), do: {:noreply, false}

end
