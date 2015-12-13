defmodule Day7 do
  use Bitwise

  @funs %{"AND" => :band,
          "OR" => :bor,
          "LSHIFT" => :bsl,
          "RSHIFT" => :bsr,
         }

  @sample ["123 -> x",
           "456 -> y",
           "x AND y -> d",
           "x OR y -> e",
           "x LSHIFT 2 -> f",
           "y RSHIFT 2 -> g",
           "NOT x -> h",
           "NOT y -> i"
          ]

  for {name, ast} <- @sample |> Enum.map(
    fn inst ->
      vals = Regex.named_captures(
        ~r/(((?<a>\w+) )?(?<fun>[A-Z]+) )?(?<b>[a-z]+)?(?<i>\d+)? -> (?<name>\w+)/, inst)
      if vals["i"] == "" do
        b = {String.to_atom(vals["b"]), [], Elixir}
      else
        b = String.to_integer(vals["i"])
      end
      ast = case vals["fun"] do
              "" -> b
              "NOT" -> {{:., [], [:erlang, :bxor]}, [],
                        [{String.to_atom(vals["b"]), [], Elixir}, 65535]}
              fun -> {{:., [], [:erlang, @funs[fun]]}, [],
                         [{String.to_atom(vals["a"]), [], Elixir}, b]}
      end
      {String.to_atom(vals["name"]), ast}
    end) do
    def unquote(name)(), do: unquote(ast)
  end

  for {name, body} <- [one: 1, two: {:+, [context: Elixir, import: Kernel],
                                     [{:one, [], Elixir}, {:one, [], Elixir}]}] do
    def unquote(name)(), do: unquote(body)
  end

end
