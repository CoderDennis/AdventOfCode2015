defmodule Day7 do
  @doc """
  Using compile-time code generation as described in _Metaprogramming Elixir_
  to create a function for each `wire`. This compiles, but never returns when
  asking for the answer.

  Because `fn` can't be used as a function name -- or at least this code
  couldn't handle it -- I appended `0` to the end of each name. That felt
  easier than checking specifically for `fn`.

  The sample circuit listed worked fine, but then found some edge cases in the
  actual input and added more to the samples to cover those. Just uncomment the
  line `for line <- @sample do` and comment out the line below that reads the
  file to see the code in action.

  Calling `Day7.a0` should provide the solution to the problem, but it never
  returns with the value. @henrik on Elixir Slack channel said he had to cache
  values to prevent endless loop or never terminating. Not sure yet how I'd do that
  with this solution.
  """

  @funs %{"AND" => :band,
          "OR" => :bor,
          "LSHIFT" => :bsl,
          "RSHIFT" => :bsr,
         }

  @sample ["123 -> x\n",
           "x AND y -> d\n",
           "x OR y -> e\n",
           "x LSHIFT 2 -> fn\n",
           "y RSHIFT 2 -> g\n",
           "NOT x -> h\n",
           "NOT y -> i\n",
           "1 AND x -> j",
           "456 -> y\n",
           "g -> k",
           "x OR fn -> fo"
          ]


  #  for line <- @sample do
  for line <- File.stream!(Path.join([__DIR__, "input.txt"]), [], :line) do
    vals = Regex.named_captures(
      ~r/(((?<a>[a-z]+)?(?<ia>\d+)? )?(?<fun>[A-Z]+) )?(?<b>[a-z]+)?(?<ib>\d+)? -> (?<name>\w+)/,
      line
    )
    if vals["ia"] == "" do
      a = {String.to_atom(vals["a"] <> "0"), [], Elixir}
    else
      a = String.to_integer(vals["ia"])
    end
    if vals["ib"] == "" do
      b = {String.to_atom(vals["b"] <> "0"), [], Elixir}
    else
      b = String.to_integer(vals["ib"])
    end
    ast = case vals["fun"] do
            "" -> b
            "NOT" -> {{:., [], [:erlang, :bxor]}, [], [b, 65535]}
            fun -> {{:., [], [:erlang, @funs[fun]]}, [], [a, b]}
          end
    # IO.puts vals["name"]
    # IO.inspect ast
    def unquote(String.to_atom(vals["name"] <> "0"))(), do: unquote(ast)
  end

#  for {name, body} <- [one: 1, two: {:+, [context: Elixir, import: Kernel],
#                                     [{:one, [], Elixir}, {:one, [], Elixir}]}] do
#    def unquote(name)(), do: unquote(body)
#  end

end
