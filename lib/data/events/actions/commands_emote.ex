defmodule Data.Events.Actions.CommandsEmote do
  @moduledoc """
  `commands/emote` action
  """

  @event_type "commands/emote"

  @derive Jason.Encoder
  defstruct [:delay, options: %{}, type: @event_type]

  @behaviour Data.Events.Actions

  @impl true
  def type(), do: @event_type

  @impl true
  def options() do
    [
      message: :string,
      status_reset: :boolean,
      status_key: :string,
      status_line: :string,
      status_listen: :string
    ]
  end
end
