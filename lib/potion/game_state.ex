defmodule Potion.GameState do
  @moduledoc """
  Manages the current state of the game including player, world, and story progress.
  """

  defstruct [
    :player,
    :world,
    :story_history,
    :current_scene,
    :turn_count,
    :metadata
  ]

  @type t :: %__MODULE__{
          player: Potion.Character.t(),
          world: Potion.World.t(),
          story_history: list(map()),
          current_scene: map(),
          turn_count: non_neg_integer(),
          metadata: map()
        }

  @doc """
  Creates a new game state with default values.
  """
  def new(player_name) do
    %__MODULE__{
      player: Potion.Character.new(player_name),
      world: Potion.World.new(),
      story_history: [],
      current_scene: nil,
      turn_count: 0,
      metadata: %{started_at: DateTime.utc_now()}
    }
  end

  @doc """
  Advances the game state by one turn.
  """
  def advance_turn(state) do
    %{state | turn_count: state.turn_count + 1}
  end

  @doc """
  Adds an event to the story history.
  """
  def add_to_history(state, event) do
    history_entry = Map.merge(event, %{
      turn: state.turn_count,
      timestamp: DateTime.utc_now()
    })

    %{state | story_history: [history_entry | state.story_history]}
  end

  @doc """
  Updates the current scene.
  """
  def set_scene(state, scene) do
    %{state | current_scene: scene}
  end

  @doc """
  Gets the recent story history (last n events).
  """
  def recent_history(state, count \\ 5) do
    Enum.take(state.story_history, count)
  end
end
