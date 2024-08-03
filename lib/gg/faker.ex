defmodule GG.Faker do
  defmacro __using__(_) do
    quote do
      @name Enum.at(@titles, 0)
      use GenServer
      require Logger

      def start_link(opts) do
        GenServer.start_link(__MODULE__, nil, Keyword.put(opts, :name, __MODULE__))
      end

      def init(nil) do
        apikey = System.fetch_env!("OPEN_AI_KEY")
        openai = OpenaiEx.new(apikey)

        {:ok, %{waiting_for_response_since: nil, timer: nil, openai: openai, runs: []},
         {:continue, :check_runs}}
      end

      def channels, do: [@channel]

      def handle_cast({:message, interaction}, state) do
        Logger.info("#{@name} received message from #{interaction.author.username}.")

        OpenaiEx.Beta.Threads.Messages.create!(state.openai, @thread_id, %{
          role: "user",
          content: """
          From: #{interaction.member.nick || interaction.author.username}
          Color: #{GG.Roles.color(interaction.member.roles) || "unknown"}

          #{interaction.content}
          """
        })

        {:noreply, state, {:continue, :schedule_response}}
      end

      def handle_continue(:reply, state) do
        case OpenaiEx.Beta.Threads.Runs.create(state.openai, %{
               thread_id: @thread_id,
               assistant_id: @assistant_id
             }) do
          {:error, error} ->
            if error.messag && is_binary(error.message) &&
                 String.contains?(error.message, "has an active run") do
              :timer.sleep(1000)
              {:noreply, state, {:continue, :reply}}
            else
              {:noreply, state}
            end

          {:ok, run} ->
            if state.timer do
              Process.cancel_timer(state.timer)
            end

            {:noreply,
             %{
               state
               | waiting_for_response_since: nil,
                 timer: nil,
                 runs: [run["id"] | state.runs]
             }}
        end
      end

      def handle_continue(:check_runs, %{runs: []} = state) do
        Process.send_after(self(), :check_runs, :timer.seconds(5))

        {:noreply, state}
      end

      def handle_continue(:check_runs, %{runs: runs} = state) do
        {new_runs, messages} =
          Enum.reduce(runs, {[], []}, fn run_id, {new_runs, messages} ->
            case OpenaiEx.Beta.Threads.Runs.retrieve(state.openai, %{
                   thread_id: @thread_id,
                   run_id: run_id
                 }) do
              {:ok, %{"status" => "completed"}} ->
                # messages =
                case OpenaiEx.Beta.Threads.Messages.list(state.openai, @thread_id, %{
                       run_id: run_id
                     }) do
                  {:ok, %{"data" => msg_objects}} ->
                    new_messages =
                      msg_objects
                      |> Enum.flat_map(fn msg_object ->
                        msg_object
                        |> Map.get("content")
                        |> Enum.flat_map(fn
                          %{"type" => "text", "text" => %{"value" => value}} ->
                            [value]

                          _ ->
                            []
                        end)
                      end)

                    {new_runs, messages ++ new_messages}

                  _ ->
                    {new_runs, messages}
                end

              _ ->
                {[run_id | new_runs], messages}
            end
          end)

        Enum.each(messages, fn message ->
          sender =
            Enum.random(@titles)

          Nostrum.Api.create_message!(@channel, """
          Incoming communique from #{sender}

          ---

          #{message}
          """)
        end)

        Process.send_after(self(), :check_runs, :timer.seconds(5))

        {:noreply, %{state | runs: new_runs}}
      end

      def handle_continue(:schedule_response, state) do
        if state.waiting_for_response_since &&
             :timer.now_diff(:erlang.timestamp(), state.waiting_for_response_since) do
          {:noreply, state, {:continue, :reply}}
        else
          timer = Process.send_after(self(), :reply, :timer.seconds(3))
          if state.timer, do: Process.cancel_timer(timer)

          {:noreply,
           %{
             state
             | timer: timer,
               waiting_for_response_since: state.waiting_for_response_since || :erlang.timestamp()
           }}
        end
      end

      def handle_info(:reply, state) do
        {:noreply, state, {:continue, :reply}}
      end

      def handle_info(:check_runs, state) do
        {:noreply, state, {:continue, :check_runs}}
      end
    end
  end
end
