defmodule GG.Roles do
  if Mix.env() == :dev do
    def green, do: 1_268_763_868_394_688_585
    def proctor, do: 1_268_763_892_616_794_213
  else
    def green, do: 1_242_209_690_734_301_336
    def proctor, do: 1_260_984_033_664_307_251
  end
end
