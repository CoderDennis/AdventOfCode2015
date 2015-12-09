defmodule Day1 do
  def floors([]), do: 0
  def floors([?\(|t]), do: floors(t) + 1
  def floors([?\)|t]), do: floors(t) - 1

  def basement_position(list), do: basement_position(list, 0, 0)

  defp basement_position(_, p, -1), do: p
  defp basement_position([?\(|t], p, f), do: basement_position(t, p+1, f+1)
  defp basement_position([?\)|t], p, f), do: basement_position(t, p+1, f-1)

end
