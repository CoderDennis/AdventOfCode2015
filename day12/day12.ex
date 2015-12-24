defmodule Day12 do

  @doc ~s"""
  #Examples

  iex> Day12.sum_of_numbers("[1,2,3]")
  6

  iex> Day12.sum_of_numbers(~s/{"a":2,"b":4}/)
  6

  iex> Day12.sum_of_numbers(~s/[[[3]]]/)
  3

  iex> Day12.sum_of_numbers(~s/{"a":{"b":4},"c":-1}/)
  3

  iex> Day12.sum_of_numbers(~s/{"a":[-1,1]}/)
  0

  iex> Day12.sum_of_numbers(~s/[-1,{"a":1}]/)
  0

  iex> Day12.sum_of_numbers(~s/[]/)
  0

  iex> Day12.sum_of_numbers(~s/{}/)
  0
  """
  def sum_of_numbers(s) do
    s
    |> String.to_char_list
    |> sum_of_numbers([], 0, 1)
  end
  defp sum_of_numbers([], [], acc, _sign), do: acc
  defp sum_of_numbers([?- | t], _nums, acc, _), do: sum_of_numbers(t, [], acc, -1)
  defp sum_of_numbers([ d | t], nums, acc, sign) when d in ?0..?9 do
    # IO.puts [d | nums]
    sum_of_numbers(t, [d | nums], acc, sign)
  end
  defp sum_of_numbers([ _ | t], [], acc, _sign), do: sum_of_numbers(t, [], acc, 1)
  defp sum_of_numbers([ _ | t], nums, acc, sign) do
    sum_of_numbers(t,
                   [],
                   (nums |> Enum.reverse |> to_integer_signed(sign)) + acc,
                   1)
  end

  defp to_integer_signed(chars, sign), do: List.to_integer(chars) * sign
end

# File.read!("input.txt") |> Day12.sum_of_numbers
