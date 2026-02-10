#!/usr/bin/env elixir

# Demo script to test the Potion game system
Mix.install([])

# Load all modules
Code.require_file("lib/potion.ex")
Code.require_file("lib/potion/character.ex")
Code.require_file("lib/potion/world.ex")
Code.require_file("lib/potion/game_state.ex")
Code.require_file("lib/potion/story_generator.ex")
Code.require_file("lib/potion/game.ex")

IO.puts("=== Potion Demo ===\n")

# Create a new game
game_state = Potion.new_game("Demo Hero")
IO.puts("✓ Created game state for: #{game_state.player.name}")

# Generate a scene
scene = Potion.StoryGenerator.generate_scene(game_state)
IO.puts("✓ Generated scene type: #{scene.event_type}")
IO.puts("\nScene Description:")
IO.puts("  #{scene.description}")

# Show choices
IO.puts("\nAvailable Choices:")
Enum.with_index(scene.choices, 1)
|> Enum.each(fn {choice, idx} ->
  IO.puts("  #{idx}. #{choice.text} (#{choice.success_chance}% success)")
end)

# Process a choice
game_state = Potion.GameState.set_scene(game_state, scene)
{:ok, new_state} = Potion.StoryGenerator.process_choice(game_state, 0)

IO.puts("\n✓ Processed choice successfully")
IO.puts("  Turn count: #{new_state.turn_count}")
IO.puts("  History events: #{length(new_state.story_history)}")

latest_event = hd(new_state.story_history)
IO.puts("\nOutcome:")
IO.puts("  Choice: #{latest_event.choice}")
IO.puts("  Result: #{latest_event.result}")
IO.puts("  Success: #{latest_event.success}")

IO.puts("\n✓ All systems operational!")
IO.puts("\nTo play interactively, run:")
IO.puts("  iex -S mix")
IO.puts("  Potion.play(\"YourName\")")
