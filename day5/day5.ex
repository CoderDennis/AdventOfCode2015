defmodule Day5 do
  @doc ~s"""
  Determines if a sring is nice

  # Examples

      iex> Day5.is_nice?("ugknbfddgicrmopn")
      true

      iex> Day5.is_nice?("aaa")
      true

      iex> Day5.is_nice?("jchzalrnumimnmhp")
      false

      iex> Day5.is_nice?("haegwjzuvuyypxyu")
      false

      iex> Day5.is_nice?("dvszwmarrgswjxmb")
      false

  """
  def is_nice?(string) do
    chars = String.to_char_list(string)
    at_least_three_vowels?(chars) &&
      twice_in_a_row_letter?(chars) &&
      does_not_contain_forbidden_strings?(chars)
  end

  defp at_least_three_vowels?(list) do
     Enum.count(list, fn x -> Enum.member?('aeiou', x) end) >= 3
  end

  defp twice_in_a_row_letter?([a | [a | _t]]), do: true
  defp twice_in_a_row_letter?([_h | t]), do: twice_in_a_row_letter?(t)
  defp twice_in_a_row_letter?(_), do: false

  defp does_not_contain_forbidden_strings?(list) do
    !(list
      |> Enum.chunk(2, 1)
      |> Enum.any?(fn x -> Enum.member?(['ab', 'cd', 'pq', 'xy'], x) end))
  end

  @doc ~s"""
  # Examples

    iex> Day5.is_nice2?("qjhvhtzxzqqjkmpb")
    true

    iex> Day5.is_nice2?("xxyxx")
    true

    iex> Day5.is_nice2?("uurcxstgmygtbstg")
    false

    iex> Day5.is_nice2?("ieodomkazucvgmuy")
    false

  """
  def is_nice2?(string) do
    false
  end

  @doc ~s"""
  # Examples

    iex> Day5.pair_appears_twice?('xyxy')
    true

    iex> Day5.pair_appears_twice?('xaabcdefgaa')
    true

    iex> Day5.pair_appears_twice?('aaa')
    false

    iex> Day5.pair_appears_twice?('abcd')
    false

  """
  def pair_appears_twice?(list) do
    list
    |> Enum.chunk(2, 1)
    |> Enum.group_by(&(&1))
    |> Enum.any?(fn {_, l} -> Enum.count(l) > 1 end)
  end
end

# iex> File.stream!("input.txt", [:read, :utf8]) |> Enum.count(&Day5.is_nice?/1)
