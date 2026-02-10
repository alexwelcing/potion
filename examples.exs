defmodule Examples do
  @moduledoc """
  Example usage of the Potion story gameplay system.
  """

  alias Potion.{GameState, StoryGenerator, Character, World}

  @doc """
  Example 1: Basic game flow
  """
  def basic_game_flow do
    IO.puts("\n=== Example 1: Basic Game Flow ===\n")

    # Create a new game
    game_state = Potion.new_game("Arthur")
    IO.puts("Created character: #{game_state.player.name}")

    # Generate and display a scene
    scene = StoryGenerator.generate_scene(game_state)
    IO.puts("Scene type: #{scene.event_type}")
    IO.puts("Description: #{scene.description}")

    # Show choices
    IO.puts("\nChoices:")

    Enum.with_index(scene.choices)
    |> Enum.each(fn {choice, idx} ->
      IO.puts("  #{idx + 1}. #{choice.text}")
    end)

    # Make a choice
    game_state = GameState.set_scene(game_state, scene)
    {:ok, new_state} = StoryGenerator.process_choice(game_state, 0)

    IO.puts("\nChoice made! Turn: #{new_state.turn_count}")
    IO.puts("Story events: #{length(new_state.story_history)}")
  end

  @doc """
  Example 2: Character progression
  """
  def character_progression do
    IO.puts("\n=== Example 2: Character Progression ===\n")

    # Create a character
    hero = Character.new("Brave Hero")
    IO.puts("Initial strength: #{hero.attributes.strength}")

    # Improve attributes through gameplay
    hero = Character.modify_attribute(hero, :strength, 5)
    IO.puts("After training: #{hero.attributes.strength}")

    # Learn skills
    hero = Character.learn_skill(hero, "swordsmanship")
    hero = Character.learn_skill(hero, "persuasion")
    IO.puts("Skills learned: #{Enum.join(hero.skills, ", ")}")

    # Gain items
    hero = Character.add_item(hero, "Magic Sword")
    hero = Character.add_item(hero, "Health Potion")
    IO.puts("Inventory: #{Enum.join(hero.inventory, ", ")}")

    # Build relationships
    hero = Character.update_relationship(hero, "Mentor", 20)
    hero = Character.update_relationship(hero, "Rival", -10)
    IO.puts("Relationship with Mentor: #{hero.relationships["Mentor"]}")
    IO.puts("Relationship with Rival: #{hero.relationships["Rival"]}")
  end

  @doc """
  Example 3: World simulation
  """
  def world_simulation do
    IO.puts("\n=== Example 3: World Simulation ===\n")

    world = World.new()
    IO.puts("Starting time: Day #{world.time.day}, Hour #{world.time.hour}")
    IO.puts("Weather: #{world.weather}")

    # Advance time
    world = World.advance_time(world, 4)
    IO.puts("After 4 hours: Day #{world.time.day}, Hour #{world.time.hour}")

    # Add NPCs
    merchant = Character.new("Traveling Merchant")
    guard = Character.new("Town Guard")
    world = World.add_npc(world, merchant)
    world = World.add_npc(world, guard)
    IO.puts("NPCs in world: #{length(world.npcs)}")

    # Update reputation
    world = World.update_reputation(world, 10)
    IO.puts("Reputation: #{world.global_state.reputation}")

    # Show locations
    IO.puts("\nAvailable locations:")

    Enum.each(world.locations, fn {key, location} ->
      IO.puts("  - #{location.name} (#{key})")
    end)
  end

  @doc """
  Example 4: Multi-turn story
  """
  def multi_turn_story do
    IO.puts("\n=== Example 4: Multi-turn Story ===\n")

    game_state = Potion.new_game("Adventurer")

    # Play 3 turns
    final_state =
      Enum.reduce(1..3, game_state, fn turn, state ->
        IO.puts("\n--- Turn #{turn} ---")
        scene = StoryGenerator.generate_scene(state)
        IO.puts("#{scene.description}")

        state = GameState.set_scene(state, scene)
        # Make a random choice
        choice_idx = rem(turn, length(scene.choices))
        {:ok, new_state} = StoryGenerator.process_choice(state, choice_idx)

        latest = hd(new_state.story_history)
        IO.puts("You chose: #{latest.choice}")
        IO.puts("Result: #{latest.result}")

        new_state
      end)

    IO.puts("\n--- Story Summary ---")
    IO.puts("Total turns: #{final_state.turn_count}")
    IO.puts("Events in history: #{length(final_state.story_history)}")

    IO.puts("\nYour journey:")

    final_state.story_history
    |> Enum.reverse()
    |> Enum.each(fn event ->
      IO.puts("  • #{event.choice} - #{if event.success, do: "Success", else: "Failure"}")
    end)
  end

  @doc """
  Example 5: Game state persistence
  """
  def state_persistence do
    IO.puts("\n=== Example 5: Game State Persistence ===\n")

    # Create and play
    game_state = Potion.new_game("Hero")
    scene = StoryGenerator.generate_scene(game_state)
    game_state = GameState.set_scene(game_state, scene)
    {:ok, game_state} = StoryGenerator.process_choice(game_state, 0)

    # Save state (serialization)
    saved_state = :erlang.term_to_binary(game_state)
    IO.puts("Game state serialized: #{byte_size(saved_state)} bytes")

    # Load state (deserialization)
    loaded_state = :erlang.binary_to_term(saved_state)
    IO.puts("Game state restored successfully!")
    IO.puts("Player name: #{loaded_state.player.name}")
    IO.puts("Turn count: #{loaded_state.turn_count}")
    IO.puts("History events: #{length(loaded_state.story_history)}")
  end

  @doc """
  Run all examples
  """
  def run_all do
    basic_game_flow()
    character_progression()
    world_simulation()
    multi_turn_story()
    state_persistence()
    IO.puts("\n✓ All examples completed!\n")
  end
end

# Run all examples if executed directly
if System.get_env("RUN_EXAMPLES") do
  Examples.run_all()
end
