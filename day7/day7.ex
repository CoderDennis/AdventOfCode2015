defmodule Day7 do
  use Bitwise

  @moduledoc """
  http://adventofcode.com/2015/day/7
  
  Using compile-time code generation as described in _Metaprogramming Elixir_
  to create a function for each `wire`.

  Because `fn` can't be used as a function name -- or at least this code
  couldn't handle it -- I prepended `wire_` to each name. That felt
  easier than checking specifically for `fn`.

  To run the sample circuit, just uncomment the  line `for line <- @sample do`
  and comment out the line below that reads the file.

  Calling `Day7.wire_a` provides the solution to the puzzle.

  Using ets table to cache the values already found. Kept that as an
  implementation detail by adding private functions that have the `tab`
  parameter.

  Thanks to suggestions on the Elixir Slack channel and this blog post
  http://ineverfinishanyth.in/2014/01/20/memoization-in-elixir/ I was able
  to make the code gen simpler and add the memoization piece.
  """

  @funs %{"AND" => "band",
          "OR" => "bor",
          "LSHIFT" => "bsl",
          "RSHIFT" => "bsr"
         }

  @sample ["123 -> x",
           "456 -> y",
           "x AND y -> d",
           "x OR y -> e",
           "x LSHIFT 2 -> f",
           "y RSHIFT 2 -> g",
           "NOT x -> h",
           "NOT y -> i",
           "1 AND x -> j",
           "g -> k",
           "x LSHIFT 2 -> fn",
           "x OR fn -> fo"
          ]

  #for line <- @sample do
  for line <- File.stream!(Path.join([__DIR__, "input.txt"]), [], :line) do
    caps = Regex.named_captures(
      ~r/((?<a>[a-z0-9]+) )?((?<fun>[A-Z]+) )?(?<b>\w+) -> (?<name>\w+)/,
      line
    )
    a = case Integer.parse(caps["a"]) do
          {val, ""} -> val
          :error -> "wire_" <> caps["a"] <> "(tab)"
        end
    b = case Integer.parse(caps["b"]) do
          {val, ""} -> val
          :error -> "wire_" <> caps["b"] <> "(tab)"
        end
    val_accesor = case caps["fun"] do
                    "" -> "#{b}"
                    "NOT" -> "bxor #{b}, 65535"
                    fun -> "#{@funs[fun]} #{a}, #{b}"
                  end
    name = "wire_" <> caps["name"]
    body0 = Code.string_to_quoted!(~s/
        tab = :ets.new(:Day7, [:private])
        result = #{name}(tab)
        :ets.delete(tab)
        result/)
    body1 = Code.string_to_quoted!(~s/
        case :ets.lookup(tab, :#{name}) do
          [] ->
            r = #{val_accesor}
            :ets.insert(tab, {:#{name}, r})
            r
          [#{name}: r] -> r
        end/)
    # IO.puts caps["name"]
    # IO.puts val_accesor
    @doc line
    def unquote(String.to_atom(name))(), do: unquote(body0)
    defp unquote(String.to_atom(name))(tab), do: unquote(body1)
  end

end
