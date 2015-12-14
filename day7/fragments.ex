defmodule Fragments do
  for {name, str} <- [one: "1", two: "one + one"] do
    def unquote(name)(), do: unquote(Code.string_to_quoted!(str))
  end
end
