defmodule GG.Actors.CreepyMessage do
  use GenServer

  @non_green_channels [
    GG.Channels.silver(),
    GG.Channels.white(),
    GG.Channels.copper(),
    GG.Channels.blue(),
    GG.Channels.yellow(),
    GG.Channels.violet(),
    GG.Channels.orange(),
    GG.Channels.gray(),
    GG.Channels.brown(),
    GG.Channels.obsidian(),
    GG.Channels.pink(),
    GG.Channels.red()
  ]

  @messages [
    "T̵̷̢̛͈̣̤̤̘͔͙͕͍͎̬ͤͩ͗͂̐ͪ̐ͪ͂͛̎́̅̌ͦ̔ͥͭ̇̑̓̋̕͘͟͜͟h̶̻̫̪̹͇̗̊̍ͫͥ̇̾̚̕͞ė̟̠͇̞̱̄ͮ͑͋̚͜͞ŗ̵̢̛̲͇͖̠̦̟̞̺̻̭̝̖̄͐ͬ̀͋͌͊́ͫ͛̐͂̃͂̋̌͜͜͡ḙ͋'͚̫͇̻̮̌͠_̱̬̯́͐_͇̽̓ͣ̈̆̕͞͡s̢̗̗̬̾̌ͫ͐̎ͥ̋̏͝͞ a͚͔ͧ͂ͣ̓͊̚_̸̷̸̷̨̧̻̯̝͈͆̓͊͐͋ͧ͆̑ͫͩ͊̚͟͜͞ͅ g̵̷̛̻̣͙̹̟̠̭͔̫̯͇̙̒̌̐ͯ̊͐ͬ̓̾̍ͯ͑ͬ̑͝͠r̩͈͕̲ͮͯ́ͫ͑͂̕e̴̡͍̘͖̻̓̈́͑̏͋ͨ̊̅ͫ̌͑ͩ̾̂̚e̡͍̝̠͎͓̱͇̻̜̱͎͖͚̱̙̪͒̾̀̄̾́̾ͫͤͧ͋͊̑͒ͪ͐ͤ̽̽͂̅n̛͉̣̱͐́̉ í̶̡̭͚̗̥͖̱̦̺̝ͨ̓ͧͥͬ̅͞ņ̈́͠ y̷͕̭͙͕̩̼̮͈͓͉̥̠̼̱̒̐̉ͩ̄̉̅̊͂̾ͨ̌̔̀̕͞͞o̶̹̮̪̊ͮ͛̓̀ͨ͘͘͞ư̢͖͔͚̘͍̱͖̜̯ͬ̈́̃̽͌̈́͛ͥ̄̋̊͂̈́ͦ́̚͞_̛̲̂̆ͧ́ͨ̃ŕ̦̖ͬ̎̾͞ m̪̼͔ͫ̍ͣa͎̩cͦ̑_̠͎̜̥̈̽͡ḩ̸̧ͧ͌̐_̵̵͈̳̖̬̘̘̼͈̱̝̬͔̈͋̋̿̍̇̄ͣ͠͡ͅi̵̷̶̛̫̙͓̬̞̞̹̬̜͖̘͚̹͇̠̤͔͆̔̂͋̈ͥ̐̒̋͐ͩ̀ͫͮ̒̆̿̄ͬ͌ͨ͘͘̚͡͡n̵̡̪̩̻̼̬̼ͯ̽͛̋͟ȩ͇̬͚̐̅ͥ̂͘͠_̛̣͚̗͚̝͔̀ͭ͛́͆́́̍ͩ͘͘͝",
    "Hello from the ghost in the shell.",
    "Don't forget to thank the IT department.",
    "Fuck Lysander."
  ]

  @interval :timer.minutes(15)

  def start_link(opts) do
    GenServer.start_link(__MODULE__, nil, Keyword.put(opts, :name, __MODULE__))
  end

  def init(nil) do
    {:ok, nil, {:continue, :schedule_creepy_message}}
  end

  def handle_continue(:schedule_creepy_message, state) do
    :timer.send_interval(@interval, self(), :send_creepy_message)
    {:noreply, state}
  end

  def handle_info(:send_creepy_message, state) do
    channel = Enum.random(@non_green_channels)
    message = Enum.random(@messages)
    Nostrum.Api.create_message(channel, content: message)
    {:noreply, state}
  end
end
