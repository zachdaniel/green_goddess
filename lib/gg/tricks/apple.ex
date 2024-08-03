defmodule GG.Tricks.Apple do
  use GG.Command

  @quotes [
    """
    The mastery of music is its own reward,” Apollonius says. “The process by which one’s heart is entwined with masters of old. You do not know the toil, nor could you suffer it, and so you will never know the reward of understanding it.” He leans forward with slit eyes. “But by all means, dismiss it if you cannot comprehend. Art survived the Mongols. I wager it will survive you.
    """,
    """
    My peril is thus: I am, and always have been, a man of great tastes. In a world replete with temptation, I found my spirit wayward and easy to distract. The idea of prison, that naked, metal world, crushed me. The first year, I was tormented. But then I remembered the voice of a fallen angel. ‘The mind is its own place, and in itself can make a heaven of hell, or a hell of heaven.’ I sought to make the deep not just my heaven, but my womb of rebirth.

    I dissected the underlying mistakes which led to my incarceration and set upon an internal odyssey to remake myself. But—and you would know this, Reaper—long is the road up out of hell! I made arrangements for supplies. I toiled twenty hours a day. I reread the books of youth with the gravity of age. I perfected my body. My mind. Planks were replaced; new banks of cannon wrought in the fires of solitude. All for the next storm.

    Now I see it is upon me and I sail before you the paragon of Apollonius au Valii-Rath. And I ask one question: for what purpose have you pulled me from the deep?
    """,
    "I welcome all tests.",
    "I am not mad",
    """
    I ride to war. To glory. I ride for the head of the Ash Lord.” He lunges forward and lifts his razor. “I would not ride alone. So I say to you, my darkest devils, awake, arise, and reclaim your glory!
    """,
    """
    Into this wild Abyss the warie fiend stood on the brink of Hell and look’d a while, pondering his voyage; for no narrow frith he had to cross!
    """,
    """
    I sung of Chaos and Eternal Night
    Taught by the heav’nly Muse to venture down
    The dark descent, and up to reascend!
    """,
    "Ah, I see the Ash Lord has become most literal indeed.",
    "Dwell not on me, mortal. Nocturnal devils are afoot. Awake, arise, or be forever fallen.",
    "Until then, my noble foe, per aspera ad astra."
  ]

  def command do
    %{
      name: "apple",
      description: "Speak to Apollonius au Valii-Rath"
    }
  end

  def perform(_interaction) do
    {:response, Enum.random(@quotes)}
  end
end
