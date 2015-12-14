defmodule Day7 do
  use Bitwise

  @moduledoc """
  Using compile-time code generation as described in _Metaprogramming Elixir_
  to create a function for each `wire`.

  Because `fn` can't be used as a function name -- or at least this code
  couldn't handle it -- I appended `0` to the end of each name. That felt
  easier than checking specifically for `fn`.

  To run the sample circuit, just uncomment the  line `for line <- @sample do`
  and comment out the line below that reads the file to see the code in action.

  Calling `Day7.a0` should provide the solution to the problem.

  This is first attempt at caching the values, but it doesn't work yet.
  """

  @funs %{"AND" => "band",
          "OR" => "bor",
          "LSHIFT" => "bsl",
          "RSHIFT" => "bsr"
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

  for line <- @sample do
  # for line <- File.stream!(Path.join([__DIR__, "input.txt"]), [], :line) do
    vals = Regex.named_captures(
      ~r/((?<a>\w+) )?((?<fun>[A-Z]+) )?(?<b>\w+) -> (?<name>\w+)/,
      line
    )
    a = case Integer.parse(vals["a"]) do
          {val, ""} -> val
          :error -> String.to_atom(vals["a"] <> "0(tab)")
        end
    b = case Integer.parse(vals["b"]) do
          {val, ""} -> val
          :error -> String.to_atom(vals["b"] <> "0(tab)")
        end
    val_accesor = case vals["fun"] do
                    "" -> vals["b"]
                    "NOT" -> "bxor x, 65535"
                    fun -> "#{@funs[fun]} #{a}, #{b}"
                  end

    name = vals["name"] <> "0"
    body = ~s/
      def #{name}() do
        tab = :ets.new(:Day7, [:private])
        #{name}(tab)
      end
      defp #{name}(tab) do
        case :ets.lookup(tab, :#{name}) do
          [] ->
            r = #{val_accesor}
            :ets.insert(tab, {:#{name}, r})
            r
          [#{name}: r] -> r
        end
      end/
    # IO.puts vals["name"]
    # IO.puts body
    IO.inspect Code.string_to_quoted!(body)
    Code.string_to_quoted!(body)
  end

end
