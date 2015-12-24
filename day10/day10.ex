defmodule Day10 do

  @doc ~s"""
  #Examples

  iex> Day10.look_and_say(1)
  [1,1]

  iex> Day10.look_and_say(11)
  [2, 1]

  iex> Day10.look_and_say(21)
  [1,2,1,1]

  iex> Day10.look_and_say(1211)
  [1,1,1,2,2,1]

  iex> Day10.look_and_say(111221)
  [3,1,2,2,1,1]
  """
  def look_and_say(sequence) when is_integer sequence do
    sequence
    |> Integer.digits
    |> look_and_say
  end
  def look_and_say(sequence) when is_list(sequence) do
    sequence
    |> do_look_and_say
    |> Enum.reverse
  end

  defp do_look_and_say([n | t]), do: do_look_and_say(n, t, 1, [])
  defp do_look_and_say(d, [], count, acc), do: [d, count] ++ acc
  defp do_look_and_say(d, [d | t], count, acc) do
    do_look_and_say(d, t, count+1, acc)
  end
  defp do_look_and_say(d, [n | t], count, acc) when count > 0 do
    do_look_and_say(n, t, 1, [d, count] ++ acc)
  end

  @doc """
  Apply `look_and_say` given number of `times` for `sequence` input
  """
  def look_and_say_times(sequence, 0), do: sequence
  def look_and_say_times(sequence, times) do
    IO.puts times

    sequence
    |> look_and_say
    |> IO.inspect
    |> look_and_say_times(times - 1)
  end
end
