defmodule Potion.WorldTest do
  use ExUnit.Case

  test "creates a new world with default state" do
    world = Potion.World.new()
    assert world.time.day == 1
    assert world.time.hour == 8
    assert world.weather == "clear"
    assert is_map(world.locations)
  end

  test "advances time correctly" do
    world = Potion.World.new()
    advanced = Potion.World.advance_time(world, 2)
    assert advanced.time.hour == 10
  end

  test "handles day transition when advancing time" do
    world = Potion.World.new()
    # Advance 20 hours from hour 8 should go to next day
    advanced = Potion.World.advance_time(world, 20)
    assert advanced.time.day == 2
    assert advanced.time.hour == 4
  end

  test "adds NPCs to world" do
    world = Potion.World.new()
    npc = Potion.Character.new("Merchant")
    world_with_npc = Potion.World.add_npc(world, npc)
    assert length(world_with_npc.npcs) == 1
  end

  test "updates reputation" do
    world = Potion.World.new()
    updated = Potion.World.update_reputation(world, 10)
    assert updated.global_state.reputation == 10
  end

  test "has multiple starting locations" do
    world = Potion.World.new()
    assert Map.has_key?(world.locations, "village")
    assert Map.has_key?(world.locations, "forest")
    assert Map.has_key?(world.locations, "tavern")
  end
end
