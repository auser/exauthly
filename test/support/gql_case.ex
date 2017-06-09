defmodule Newline.GqlCase do
  defmacro __using__(opts) do
    quote do
      use ExUnit.Case, unquote(opts)
      import ExUnit.Case

      def run(document, schema, options \\ []) do
        Absinthe.run(document, schema, options)
      end
    end
  end
end
