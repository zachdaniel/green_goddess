defmodule GG.Tricks.Backflip do
  use GG.Command

  def command do
    %{
      name: "backflip",
      description: "Do a backflip, in honor of @Axom"
    }
  end

  def perform(_interaction) do
    {:response, "I'm literally a computer I can't do flips. You're a green you should know that."}
  end
end
