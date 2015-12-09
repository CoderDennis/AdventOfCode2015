defmodule Day2 do

  def sides(string) do
    string
    |> String.strip
    |> String.split("x")
    |> Enum.map(&String.to_integer/1)
  end

  def area_of_sides([l, w, h]), do: [l*w, w*h, h*l]
  def area_of_sides(string) do
    string
    |> sides
    |> area_of_sides
  end

  def surface_area(string) do
    string
    |> area_of_sides
    |> Enum.map(&(&1*2))
    |> Enum.sum
  end

  def paper_required(string) do
    sides = area_of_sides(string)
    smallest = Enum.min(sides)
    (sides
     |> Enum.map(&(&1*2))
     |> Enum.sum) + smallest
  end

  def ribbon(string) do
    sides =
    (string
     |> sides
     |> Enum.sort)
    ribbon_to_wrap(sides) + ribbon_for_bow(sides)
  end

  defp ribbon_to_wrap([a, b, _]), do: a+a+b+b

  defp ribbon_for_bow([a, b, c]), do: a*b*c

end

# File.stream!("input.txt", [:read, :utf8]) |> Stream.map(&Day2.paper_required/1) |> Enum.sum
