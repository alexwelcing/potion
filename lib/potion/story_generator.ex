defmodule Potion.StoryGenerator do
  @moduledoc """
  Generates dynamic story content based on game state.
  """

  @doc """
  Generates a new story scene based on the current game state.
  """
  def generate_scene(game_state) do
    context = build_context(game_state)
    event = select_event(game_state)
    choices = generate_choices(event, game_state)

    %{
      description: generate_description(event, context),
      event_type: event.type,
      choices: choices,
      context: context
    }
  end

  @doc """
  Processes a player's choice and determines consequences.
  """
  def process_choice(game_state, choice_index) do
    scene = game_state.current_scene
    choice = Enum.at(scene.choices, choice_index)

    if choice do
      {:ok, apply_consequences(game_state, choice)}
    else
      {:error, "Invalid choice"}
    end
  end

  defp build_context(game_state) do
    %{
      player_name: game_state.player.name,
      location: get_current_location(game_state),
      time: game_state.world.time,
      weather: game_state.world.weather,
      recent_events: Potion.GameState.recent_history(game_state, 3)
    }
  end

  defp select_event(_game_state) do
    event_types = [
      %{type: :encounter, weight: 3},
      %{type: :discovery, weight: 2},
      %{type: :challenge, weight: 2},
      %{type: :social, weight: 2},
      %{type: :mystery, weight: 1}
    ]

    weighted_random(event_types)
  end

  defp generate_choices(event, game_state) do
    base_choices = base_choices_for_event(event.type)

    # Modify choices based on character attributes
    modify_choices_for_character(base_choices, game_state.player)
  end

  defp base_choices_for_event(:encounter) do
    [
      %{text: "Approach peacefully", type: :diplomatic, stat: :charisma},
      %{text: "Prepare for combat", type: :aggressive, stat: :strength},
      %{text: "Observe from distance", type: :cautious, stat: :intelligence},
      %{text: "Attempt to flee", type: :evasive, stat: :luck}
    ]
  end

  defp base_choices_for_event(:discovery) do
    [
      %{text: "Investigate thoroughly", type: :curious, stat: :intelligence},
      %{text: "Take what's valuable", type: :greedy, stat: :luck},
      %{text: "Leave it untouched", type: :cautious, stat: :wisdom},
      %{text: "Report to authorities", type: :lawful, stat: :charisma}
    ]
  end

  defp base_choices_for_event(:challenge) do
    [
      %{text: "Face it head-on", type: :brave, stat: :strength},
      %{text: "Find another way", type: :clever, stat: :intelligence},
      %{text: "Seek assistance", type: :social, stat: :charisma},
      %{text: "Retreat for now", type: :tactical, stat: :wisdom}
    ]
  end

  defp base_choices_for_event(:social) do
    [
      %{text: "Be honest", type: :truthful, stat: :charisma},
      %{text: "Deceive them", type: :deceptive, stat: :intelligence},
      %{text: "Remain silent", type: :reserved, stat: :wisdom},
      %{text: "Charm them", type: :charming, stat: :charisma}
    ]
  end

  defp base_choices_for_event(:mystery) do
    [
      %{text: "Investigate clues", type: :investigative, stat: :intelligence},
      %{text: "Ask locals", type: :social, stat: :charisma},
      %{text: "Search for evidence", type: :thorough, stat: :luck},
      %{text: "Ignore it", type: :dismissive, stat: :wisdom}
    ]
  end

  defp modify_choices_for_character(choices, player) do
    Enum.map(choices, fn choice ->
      stat_value = Map.get(player.attributes, choice.stat, 10)
      success_chance = calculate_success_chance(stat_value)
      Map.put(choice, :success_chance, success_chance)
    end)
  end

  defp calculate_success_chance(stat_value) do
    min(90, max(10, stat_value * 5))
  end

  defp generate_description(event, context) do
    templates = description_templates_for_event(event.type)
    template = Enum.random(templates)
    interpolate_template(template, context)
  end

  defp description_templates_for_event(:encounter) do
    [
      "As {player_name} walks through {location}, a figure emerges from the shadows.",
      "The path ahead is blocked by an unexpected presence.",
      "A stranger approaches {player_name} with purposeful strides."
    ]
  end

  defp description_templates_for_event(:discovery) do
    [
      "{player_name} notices something unusual near the path.",
      "A glint of something catches {player_name}'s eye.",
      "There's something hidden here, waiting to be found."
    ]
  end

  defp description_templates_for_event(:challenge) do
    [
      "A daunting obstacle lies ahead for {player_name}.",
      "The situation demands immediate action.",
      "{player_name} faces a difficult decision."
    ]
  end

  defp description_templates_for_event(:social) do
    [
      "A conversation begins that could change everything.",
      "Words will matter more than actions here.",
      "{player_name} must choose their words carefully."
    ]
  end

  defp description_templates_for_event(:mystery) do
    [
      "Something strange is happening in {location}.",
      "The pieces of a puzzle are beginning to emerge.",
      "Questions arise that demand answers."
    ]
  end

  defp interpolate_template(template, context) do
    template
    |> String.replace("{player_name}", context.player_name)
    |> String.replace("{location}", context.location)
  end

  defp apply_consequences(game_state, choice) do
    # Roll for success based on choice difficulty
    success = roll_success(choice.success_chance)

    # Update game state based on outcome
    game_state
    |> apply_attribute_changes(choice, success)
    |> apply_story_outcome(choice, success)
    |> Potion.GameState.advance_turn()
  end

  defp roll_success(chance) do
    :rand.uniform(100) <= chance
  end

  defp apply_attribute_changes(game_state, choice, success) do
    change = if success, do: 1, else: -1

    new_player = Potion.Character.modify_attribute(game_state.player, choice.stat, change)

    %{game_state | player: new_player}
  end

  defp apply_story_outcome(game_state, choice, success) do
    outcome = %{
      choice: choice.text,
      type: choice.type,
      success: success,
      result: generate_outcome_text(choice, success)
    }

    Potion.GameState.add_to_history(game_state, outcome)
  end

  defp generate_outcome_text(choice, true) do
    "Your #{choice.type} approach succeeds!"
  end

  defp generate_outcome_text(choice, false) do
    "Your #{choice.type} approach doesn't quite work out as planned."
  end

  defp get_current_location(_game_state) do
    "the village"
  end

  defp weighted_random(items) do
    total_weight = Enum.sum(Enum.map(items, & &1.weight))
    random = :rand.uniform(total_weight)

    Enum.reduce_while(items, 0, fn item, acc ->
      new_acc = acc + item.weight

      if random <= new_acc do
        {:halt, item}
      else
        {:cont, new_acc}
      end
    end)
  end
end
