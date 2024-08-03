defmodule GG.Roles do
  @roles [
    green: 1_268_763_868_394_688_585,
    silver: 1_268_953_485_383_041_065,
    white: 1_268_953_698_407_682_190,
    copper: 1_268_953_812_413_059_146,
    blue: 1_268_953_974_296_281_089,
    yellow: 1_268_954_033_503_207_580,
    violet: 1_268_954_094_601_633_804,
    orange: 1_268_954_190_470_840_451,
    gray: 1_268_954_185_282_621_523,
    brown: 1_268_954_453_650_702_396,
    obsidian: 1_268_954_619_904_786_523,
    pink: 1_268_954_767_531_704_463,
    red: 1_268_954_829_011_554_384,
    gold: 1_269_402_814_401_220_702
  ]

  for {role, id} <- @roles do
    def unquote(role)(), do: unquote(id)
  end

  def proctor, do: 1_268_763_892_616_794_213

  def color(roles) do
    Enum.find_value(roles, fn member_role_id ->
      Enum.find_value(@roles, fn {role, id} ->
        if id == member_role_id do
          role
        end
      end)
    end)
  end
end
