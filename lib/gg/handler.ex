defmodule GG.Command do
  defmacro __using__(_) do
    quote do
      alias Nostrum.Api

      @callback command() :: map
      @callback perform(Nostrum.Struct.Interaction.t()) :: term()

      def greens_only?, do: true

      defoverridable greens_only?: 0
    end
  end
end
