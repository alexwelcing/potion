defmodule Potion.GameStateTest do
  use ExUnit.Case

  test "creates new game state" do
    state = Potion.GameState.new("Hero")
    assert state.player.name == "Hero"
    assert state.turn_count == 0
    assert state.story_history == []
  end

  test "advances turn count" do
    state = Potion.GameState.new("Hero")
    advanced = Potion.GameState.advance_turn(state)
    assert advanced.turn_count == 1
  end

  test "adds events to history" do
    state = Potion.GameState.new("Hero")
    event = %{type: :encounter, outcome: :success}
    updated = Potion.GameState.add_to_history(state, event)
    assert length(updated.story_history) == 1
    assert hd(updated.story_history).type == :encounter
  end

  test "history includes turn and timestamp" do
    state = Potion.GameState.new("Hero")
    event = %{type: :discovery}
    updated = Potion.GameState.add_to_history(state, event)
    history_entry = hd(updated.story_history)
    assert Map.has_key?(history_entry, :turn)
    assert Map.has_key?(history_entry, :timestamp)
  end

  test "sets current scene" do
    state = Potion.GameState.new("Hero")
    scene = %{description: "A dark forest", choices: []}
    updated = Potion.GameState.set_scene(state, scene)
    assert updated.current_scene == scene
  end

  test "gets recent history" do
    state = Potion.GameState.new("Hero")
    # Add multiple events
    state =
      Enum.reduce(1..10, state, fn i, acc ->
        Potion.GameState.add_to_history(acc, %{event: i})
      end)

    recent = Potion.GameState.recent_history(state, 3)
    assert length(recent) == 3
    # Most recent should be first
    assert hd(recent).event == 10
  end
end
