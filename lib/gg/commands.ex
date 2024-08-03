defmodule GG.Commands do
  use Nostrum.Consumer

  @commands [
    GG.Tricks.Backflip
  ]

  require Logger

  def handle_event({:READY, _msg, _ws_state}) do
    for module <- @commands do
      Nostrum.Api.create_guild_application_command(GG.server_id(), module.command())
    end
  end

  for module <- @commands do
    def handle_event(
          {:INTERACTION_CREATE,
           %Nostrum.Struct.Interaction{data: %{name: unquote(module.command().name)}} =
             interaction, _ws_state}
        ) do
      if unquote(module).greens_only?() && !caller_is_green?(interaction) do
        response =
          if caller_is_proctor?(interaction) do
            "Only a green in the machine, even for proctors ;)"
          else
            "Only a green in the machine ;)"
          end

        Nostrum.Api.create_interaction_response(interaction, %{
          type: 4,
          data: %{
            content: response
          }
        })
      else
        case unquote(module).perform(interaction) do
          {:response, response} ->
            Nostrum.Api.create_interaction_response(interaction, %{
              type: 4,
              data: %{
                content: response
              }
            })

          _ ->
            :ok
        end
      end
    end
  end

  @role_choice GG.Channels.role_choice()
  def handle_event({:MESSAGE_REACTION_ADD, %{channel_id: channel_id} = interaction, _ws_state}) when channel_id == @role_choice do
    roles = %{
      "Green" => GG.Roles.green(),
      "Silver" => GG.Roles.silver(),
      "White" => GG.Roles.white(),
      "Copper" => GG.Roles.copper(),
      "Blue" => GG.Roles.blue(),
      "Yellow" => GG.Roles.yellow(),
      "Violet" => GG.Roles.violet(),
      "Orange" => GG.Roles.orange(),
      "Gray" => GG.Roles.gray(),
      "Brown" => GG.Roles.brown(),
      "Obsidian" => GG.Roles.obsidian(),
      "Pink" => GG.Roles.pink(),
      "Red" => GG.Roles.red()
    }

    role_to_grant = roles[interaction.emoji.name]

    if role_to_grant && !Enum.any?(interaction.member.roles, &(&1 in Map.values(roles))) do
      Nostrum.Api.add_guild_member_role(GG.server_id(), interaction.user_id, role_to_grant)
    end
  end

  def handle_event({:MESSAGE_REACTION_REMOVE, %{channel_id: channel_id} = interaction, _ws_state}) when channel_id == @role_choice do
    roles = %{
      "Green" => GG.Roles.green(),
      "Silver" => GG.Roles.silver(),
      "White" => GG.Roles.white(),
      "Copper" => GG.Roles.copper(),
      "Blue" => GG.Roles.blue(),
      "Yellow" => GG.Roles.yellow(),
      "Violet" => GG.Roles.violet(),
      "Orange" => GG.Roles.orange(),
      "Gray" => GG.Roles.gray(),
      "Brown" => GG.Roles.brown(),
      "Obsidian" => GG.Roles.obsidian(),
      "Pink" => GG.Roles.pink(),
      "Red" => GG.Roles.red()
    }

    role_to_remove = roles[interaction.emoji.name]

    if role_to_remove do
      Nostrum.Api.remove_guild_member_role(GG.server_id(), interaction.user_id, role_to_remove)
    end
  end

  def handle_event(_other) do
    # IO.inspect(other)
    :ok
  end

  defp caller_is_green?(interaction) do
    interaction.member.roles |> Enum.any?(&(&1 == GG.Roles.green()))
  end

  defp caller_is_proctor?(interaction) do
    interaction.member.roles |> Enum.any?(&(&1 == GG.Roles.proctor()))
  end
end
