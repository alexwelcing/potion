# Potion - Endless Generative Story Gameplay

An Elixir/BEAM-based endless story gameplay system inspired by Fable. Potion generates dynamic, branching narratives with procedural content generation, character progression, and meaningful player choices.

## Overview

Potion is a framework for creating endless, generative story-driven gameplay experiences. It combines:

- **Dynamic Story Generation**: Procedurally generated scenes and events based on game state
- **Character System**: Rich character attributes, skills, relationships, and progression
- **World Simulation**: Living world with time, weather, locations, and NPCs
- **Meaningful Choices**: Player decisions that impact character development and story direction
- **State Management**: Comprehensive game state tracking with history and persistence capabilities

## Features

### Story Generation Engine
- Multiple event types (encounters, discoveries, challenges, social interactions, mysteries)
- Context-aware narrative generation
- Weighted random event selection
- Dynamic choice generation based on character attributes

### Character Progression
- Attributes: strength, intelligence, charisma, luck, morality
- Skills system with learning mechanics
- Inventory management
- Relationship tracking with NPCs
- Character backstory integration

### World System
- Multiple interconnected locations
- Time and weather simulation
- Global reputation system
- NPC management
- Dynamic world events

### Gameplay Mechanics
- Turn-based gameplay loop
- Success/failure rolls based on character stats
- Consequence system that affects character and world
- Story history tracking
- Save/load capabilities (via game state serialization)

## Installation

### Prerequisites
- Erlang/OTP 25+
- Elixir 1.14+

### Setup
```bash
# Clone the repository
git clone https://github.com/alexwelcing/potion.git
cd potion

# Compile the project
mix compile

# Run tests
mix test
```

## Quick Start

### Interactive Play
Start an interactive story session:

```elixir
# Start IEx with the project
iex -S mix

# Begin your adventure
Potion.play("YourHeroName")
```

### Programmatic Usage

```elixir
# Create a new game state
game_state = Potion.new_game("Hero")

# Generate a scene
scene = Potion.StoryGenerator.generate_scene(game_state)

# Present choices to the player
# scene.choices contains available options

# Process a player's choice (0-indexed)
{:ok, new_state} = Potion.StoryGenerator.process_choice(game_state, 0)
```

## Architecture

### Core Modules

- **Potion**: Main API and entry point
- **Potion.Game**: Game loop and interaction management
- **Potion.GameState**: Central game state management
- **Potion.Character**: Character creation and management
- **Potion.World**: World state and simulation
- **Potion.StoryGenerator**: Procedural narrative generation engine

### Data Flow

```
Player Input → Game Loop → Story Generator → Game State Update → Display
                ↓                                    ↓
            World State ← Character State ← Story History
```

## Gameplay

### Turn Structure
1. Scene is generated based on current game state
2. Player is presented with description and choices
3. Player selects an action
4. Success/failure is determined by character attributes
5. Consequences are applied to character and world
6. Turn advances and new scene is generated

### Event Types

- **Encounter**: Meet NPCs or creatures (diplomatic, aggressive, cautious, or evasive responses)
- **Discovery**: Find items, locations, or secrets
- **Challenge**: Face obstacles requiring skill or strategy
- **Social**: Navigate conversations and relationships
- **Mystery**: Investigate clues and solve problems

### Character Development

Characters grow through their choices:
- Successful actions improve related attributes
- Failed actions provide learning opportunities
- Skills can be acquired through gameplay
- Relationships develop based on interactions
- Morality shifts based on decisions

## Example Session

```
=== Welcome to Potion: Endless Story ===
Player: Arthur

Your adventure begins...

📖 As Arthur walks through the village, a figure emerges from the shadows.

What do you do?

  1. Approach peacefully ✓✓
  2. Prepare for combat ✓
  3. Observe from distance ✓
  4. Attempt to flee ⚠

> 1

Your diplomatic approach succeeds!

Turn 1
Player: Arthur
...
```

## Development

### Running Tests
```bash
# Run all tests
mix test

# Run specific test file
mix test test/potion/character_test.exs

# Run with coverage
mix test --cover
```

### Code Formatting
```bash
# Check formatting
mix format --check-formatted

# Apply formatting
mix format
```

## Extending Potion

### Adding New Event Types

Add to `Potion.StoryGenerator`:

```elixir
defp base_choices_for_event(:custom_event) do
  [
    %{text: "Custom choice 1", type: :custom, stat: :intelligence},
    # ... more choices
  ]
end

defp description_templates_for_event(:custom_event) do
  [
    "A custom event occurs...",
    # ... more templates
  ]
end
```

### Custom World Locations

Modify `Potion.World.initialize_locations/0`:

```elixir
defp initialize_locations do
  %{
    "custom_location" => %{
      name: "Custom Place",
      description: "Description of the place",
      connections: ["other_location"]
    }
  }
end
```

## Future Enhancements

Potential areas for expansion:
- AI/LLM integration for truly dynamic content generation
- Multiplayer support via distributed Elixir
- Combat system with tactical elements
- Crafting and economy simulation
- Quest system with objectives
- Save/load via persistence layer (ETS/Mnesia/Database)
- Web interface using Phoenix LiveView
- Voice narration integration

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is available as open source.

## Acknowledgments

Inspired by the Fable series and procedural storytelling in games like Dwarf Fortress and AI Dungeon.

