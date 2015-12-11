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
    chars = String.to_char_list(string)
    pair_appears_twice?(chars) &&
      letter_repeats_with_one_between?(chars)
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
    |> Enum.any?(fn p -> sublist_count(p, list, 0) > 1 end)
  end

  defp sublist_count([a | [b | []]] = pair, [a | [b | t]], count) do
    sublist_count(pair, t, count + 1)
  end
  defp sublist_count(pair, [_h | t], count), do: sublist_count(pair, t, count)
  defp sublist_count(_, [], count), do: count

  @doc ~s"""
  # Examples

  iex> Day5.letter_repeats_with_one_between?('xyx')
  true

  iex> Day5.letter_repeats_with_one_between?('abcdefeghi')
  true

  iex> Day5.letter_repeats_with_one_between?('aaa')
  true

  iex> Day5.letter_repeats_with_one_between?('uurcxstgmygtbstg')
  false

  """
  def letter_repeats_with_one_between?([]), do: false
  def letter_repeats_with_one_between?([x | [_y | [x | _]]]), do: true
  def letter_repeats_with_one_between?([_h | t]) do
    letter_repeats_with_one_between?(t)
  end
end

# iex> File.stream!("input.txt", [:read, :utf8]) |> Enum.count(&Day5.is_nice?/1)
