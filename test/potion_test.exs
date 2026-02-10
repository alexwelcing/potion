defmodule PotionTest do
  use ExUnit.Case
  doctest Potion

  test "creates a new game state" do
    game_state = Potion.new_game("TestHero")
    assert game_state.player.name == "TestHero"
    assert game_state.turn_count == 0
  end

  test "new game has initialized character" do
    game_state = Potion.new_game("Hero")
    assert game_state.player.attributes.strength == 10
    assert game_state.player.attributes.intelligence == 10
    assert game_state.player.skills == []
  end

  test "new game has initialized world" do
    game_state = Potion.new_game("Hero")
    assert game_state.world.time.day == 1
    assert is_map(game_state.world.locations)
  end
end
