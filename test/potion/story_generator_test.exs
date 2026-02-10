defmodule Potion.StoryGeneratorTest do
  use ExUnit.Case

  test "generates a scene with required fields" do
    game_state = Potion.GameState.new("Hero")
    scene = Potion.StoryGenerator.generate_scene(game_state)

    assert is_binary(scene.description)
    assert is_list(scene.choices)
    assert length(scene.choices) > 0
    assert Map.has_key?(scene, :event_type)
  end

  test "generated choices have required fields" do
    game_state = Potion.GameState.new("Hero")
    scene = Potion.StoryGenerator.generate_scene(game_state)
    choice = hd(scene.choices)

    assert Map.has_key?(choice, :text)
    assert Map.has_key?(choice, :type)
    assert Map.has_key?(choice, :success_chance)
  end

  test "success chance is within valid range" do
    game_state = Potion.GameState.new("Hero")
    scene = Potion.StoryGenerator.generate_scene(game_state)

    Enum.each(scene.choices, fn choice ->
      assert choice.success_chance >= 10
      assert choice.success_chance <= 90
    end)
  end

  test "processes valid choice" do
    game_state = Potion.GameState.new("Hero")
    scene = Potion.StoryGenerator.generate_scene(game_state)
    game_state = Potion.GameState.set_scene(game_state, scene)

    {:ok, updated_state} = Potion.StoryGenerator.process_choice(game_state, 0)
    assert updated_state.turn_count == game_state.turn_count + 1
    assert length(updated_state.story_history) > length(game_state.story_history)
  end

  test "rejects invalid choice index" do
    game_state = Potion.GameState.new("Hero")
    scene = Potion.StoryGenerator.generate_scene(game_state)
    game_state = Potion.GameState.set_scene(game_state, scene)

    result = Potion.StoryGenerator.process_choice(game_state, 999)
    assert result == {:error, "Invalid choice"}
  end
end
