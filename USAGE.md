# Usage Guide

This guide provides practical examples of using the Potion story gameplay system.

## Running Examples

To run all examples:

```bash
cd potion
RUN_EXAMPLES=1 elixir -r lib/potion.ex -r lib/potion/character.ex -r lib/potion/world.ex -r lib/potion/game_state.ex -r lib/potion/story_generator.ex -r lib/potion/game.ex examples.exs
```

Or load them in IEx:

```bash
iex -S mix
iex> Code.require_file("examples.exs")
iex> Examples.basic_game_flow()
iex> Examples.character_progression()
iex> Examples.world_simulation()
iex> Examples.multi_turn_story()
iex> Examples.state_persistence()
```

## Quick Start for Development

### 1. Start an Interactive Game

```elixir
iex -S mix
Potion.play("YourName")
```

### 2. Create a Custom Game Loop

```elixir
# Create game state
game_state = Potion.new_game("Hero")

# Generate a scene
scene = Potion.StoryGenerator.generate_scene(game_state)

# Display to player
IO.puts(scene.description)
Enum.each(scene.choices, fn choice ->
  IO.puts("- #{choice.text}")
end)

# Process player choice
game_state = Potion.GameState.set_scene(game_state, scene)
{:ok, new_state} = Potion.StoryGenerator.process_choice(game_state, 0)
```

### 3. Character Management

```elixir
# Create character
hero = Potion.Character.new("Brave Knight")

# Modify attributes
hero = Potion.Character.modify_attribute(hero, :strength, 10)

# Learn skills
hero = Potion.Character.learn_skill(hero, "combat")

# Add items
hero = Potion.Character.add_item(hero, "Sword")

# Update relationships
hero = Potion.Character.update_relationship(hero, "King", 50)
```

### 4. World Simulation

```elixir
# Create world
world = Potion.World.new()

# Advance time
world = Potion.World.advance_time(world, 2)  # 2 hours

# Add NPCs
npc = Potion.Character.new("Merchant")
world = Potion.World.add_npc(world, npc)

# Update reputation
world = Potion.World.update_reputation(world, 10)
```

### 5. Story Generation

```elixir
# Generate scene
game_state = Potion.new_game("Hero")
scene = Potion.StoryGenerator.generate_scene(game_state)

# Access scene properties
scene.description        # String
scene.event_type         # :encounter | :discovery | :challenge | :social | :mystery
scene.choices            # List of choice maps

# Each choice contains:
# - text: Description of the choice
# - type: Choice type
# - stat: Relevant character attribute
# - success_chance: Probability of success (10-90)
```

### 6. Game State Management

```elixir
# Create state
state = Potion.GameState.new("Hero")

# Advance turn
state = Potion.GameState.advance_turn(state)

# Add to history
event = %{type: :combat, result: :victory}
state = Potion.GameState.add_to_history(state, event)

# Get recent history
recent = Potion.GameState.recent_history(state, 5)

# Set scene
scene = Potion.StoryGenerator.generate_scene(state)
state = Potion.GameState.set_scene(state, scene)
```

### 7. Saving and Loading

```elixir
# Save game
saved = :erlang.term_to_binary(game_state)
File.write!("savegame.bin", saved)

# Load game
{:ok, saved} = File.read("savegame.bin")
game_state = :erlang.binary_to_term(saved)
```

## Testing

Run all tests:

```bash
mix test
```

Run specific test:

```bash
mix test test/potion/character_test.exs
```

## Code Formatting

Format all code:

```bash
mix format
```

Check if formatted:

```bash
mix format --check-formatted
```

## Extending the System

### Adding New Event Types

1. Add event type to `select_event/1` in `story_generator.ex`
2. Add choices in `base_choices_for_event/1`
3. Add description templates in `description_templates_for_event/1`

### Adding New Locations

Edit `initialize_locations/0` in `world.ex`:

```elixir
defp initialize_locations do
  %{
    "new_location" => %{
      name: "Location Name",
      description: "Description",
      connections: ["village"]
    }
  }
end
```

### Adding Custom Attributes

Modify `Character.new/1` in `character.ex`:

```elixir
attributes: %{
  strength: 10,
  intelligence: 10,
  charisma: 10,
  luck: 10,
  wisdom: 10,
  morality: 50,
  custom_stat: 10  # Your new attribute
}
```

## Tips and Best Practices

1. **Character Progression**: Attributes typically range from 0-100. Starting value is 10.
2. **Success Chances**: Calculated as `stat_value * 5`, capped between 10-90%.
3. **Story History**: Always check recent history when generating contextual content.
4. **World Time**: Time advances automatically; use `advance_time/2` for custom intervals.
5. **Save States**: Erlang term serialization is efficient for saving game state.

## Common Patterns

### Multi-turn Game Loop

```elixir
defmodule MyGame do
  def play(name, turns \\ 10) do
    state = Potion.new_game(name)
    Enum.reduce(1..turns, state, fn _turn, state ->
      scene = Potion.StoryGenerator.generate_scene(state)
      state = Potion.GameState.set_scene(state, scene)
      
      # Player makes choice (simplified)
      choice_index = :rand.uniform(length(scene.choices)) - 1
      {:ok, new_state} = Potion.StoryGenerator.process_choice(state, choice_index)
      
      new_state
    end)
  end
end
```

### Custom Story Templates

```elixir
defmodule CustomStory do
  def generate_custom_description(context) do
    templates = [
      "In {location}, {player_name} encounters something unexpected...",
      "The {weather} day brings {player_name} to a crossroads..."
    ]
    
    template = Enum.random(templates)
    template
    |> String.replace("{player_name}", context.player_name)
    |> String.replace("{location}", context.location)
    |> String.replace("{weather}", context.weather)
  end
end
```

## Troubleshooting

**Issue**: Tests fail after adding custom attributes
- **Solution**: Update all tests to match new character structure

**Issue**: Scene generation returns nil
- **Solution**: Ensure game_state has valid player and world structures

**Issue**: Save file can't be loaded
- **Solution**: Ensure same Elixir version and module definitions when loading

## Further Reading

- See `README.md` for architecture overview
- Check `examples.exs` for practical examples
- Review test files for usage patterns
- Read module documentation with `h ModuleName` in IEx
