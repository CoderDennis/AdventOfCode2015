defmodule Day3 do
  def houses(input) do
    input
    |> String.to_char_list
    |> houses([{0,0}])
    |> Enum.uniq
    |> Enum.count
  end

  def houses([], visited), do: visited
  def houses([?>|t], [{x,y}|_] = visited), do: houses(t, [{x+1,y}|visited])
  def houses([?<|t], [{x,y}|_] = visited), do: houses(t, [{x-1,y}|visited])
  def houses([?^|t], [{x,y}|_] = visited), do: houses(t, [{x,y+1}|visited])
  def houses([?v|t], [{x,y}|_] = visited), do: houses(t, [{x,y-1}|visited])
end

# File.read!("input.txt") |> Day3.houses
