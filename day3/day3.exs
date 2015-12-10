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

  def houses2(input) do
    {a, b} = input
    |> String.to_char_list
    |> Enum.with_index
    |> Enum.partition(fn {_e, i} -> rem(i,2) == 0 end)
    santa = a
    |> Enum.map(fn {e, _i} -> e end)
    |> houses([{0,0}])
    robo_santa = b
    |> Enum.map(fn {e, _i} -> e end)
    |> houses([{0,0}])
    Enum.concat(santa, robo_santa)
    |> Enum.uniq
    |> Enum.count
  end

end

# File.read!("input.txt") |> Day3.houses
