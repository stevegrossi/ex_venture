defmodule Game.NPC.Actions.CommandsEmote do
  @moduledoc """
  Speak to the room that the NPC is in
  """

  use Game.Environment

  alias Game.Format
  alias Game.Message
  alias Game.NPC.Events
  alias Game.NPC.Status

  @doc """
  Emote to the room
  """
  def act(state, action) do
    message = action.options.message

    message = Message.npc_emote(state.npc, Format.resources(message))
    state.room_id |> @environment.emote(Events.npc(state), message)
    Events.broadcast(state.npc, "room/heard", message)

    state = maybe_update_status(state, action)

    {:ok, state}
  end

  @doc """
  Maybe update the status of the NPC
  """
  def maybe_update_status(state, action) do
    case has_status_keys?(action.options) do
      true ->
        merge_status(state, action.options)

      false ->
        state
    end
  end

  @doc """
  Check if the action has status altering options

      iex> CommandsEmote.has_status_keys?(%{})
      false

      iex> CommandsEmote.has_status_keys?(%{status_reset: true})
      true

      iex> CommandsEmote.has_status_keys?(%{status_key: "start", status_line: ""})
      true
  """
  def has_status_keys?(options) do
    status_keys = [:status_reset, :status_key, :status_line, :status_listen]

    Enum.any?(status_keys, fn key ->
      Map.has_key?(options, key)
    end)
  end

  defp merge_status(state, options) do
    status =
      case options do
        %{status_reset: true} ->
          %{npc: npc} = state

          %Status{
            key: "start",
            line: npc.status_line,
            listen: npc.status_listen
          }

        _ ->
          %Status{
            key: options.status_key,
            line: Map.get(options, :status_line),
            listen: Map.get(options, :status_listen)
          }
      end

    %{state | status: status}
  end
end
