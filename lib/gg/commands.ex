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

  def handle_event({_event, _msg, _ws_state}) do
    :ok
  end

  defp caller_is_green?(interaction) do
    interaction.member.roles |> Enum.any?(&(&1 == GG.Roles.green()))
  end

  defp caller_is_proctor?(interaction) do
    interaction.member.roles |> Enum.any?(&(&1 == GG.Roles.proctor()))
  end
end
