defmodule Day4 do

  def is_advent_coin?(string) do
    string
    |> :crypto.md5
    |> Base.encode16
    |> String.starts_with?("000000")
  end
end

# Stream.iterate(1, &(&1+1)) |> Stream.drop_while(&(!Day4.is_advent_coin?("bgvyzdsv#{&1}"))) |> Enum.take(1)
