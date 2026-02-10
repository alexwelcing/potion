defmodule Potion.Game do
  @moduledoc """
  Main game loop and coordination module for the Potion story gameplay system.
  """

  alias Potion.{GameState, StoryGenerator}

  @doc """
  Starts a new game with the given player name.
  """
  def start_game(player_name) do
    game_state = GameState.new(player_name)

    IO.puts("\n=== Welcome to Potion: Endless Story ===")
    IO.puts("Player: #{player_name}")
    IO.puts("\nYour adventure begins...\n")

    game_state
    |> generate_and_present_scene()
    |> game_loop()
  end

  @doc """
  Main game loop - continues until the player quits.
  """
  def game_loop(game_state) do
    IO.puts("\n" <> String.duplicate("=", 60))
    IO.puts("Turn #{game_state.turn_count}")
    IO.puts("Player: #{game_state.player.name}")
    IO.puts(String.duplicate("=", 60) <> "\n")

    case prompt_for_action() do
      :quit ->
        IO.puts("\nThanks for playing! Your story continues in memory...")
        game_state

      :status ->
        display_status(game_state)
        game_loop(game_state)

      :continue ->
        game_state
        |> generate_and_present_scene()
        |> game_loop()

      {:choose, index} ->
        case StoryGenerator.process_choice(game_state, index) do
          {:ok, new_state} ->
            game_loop(new_state)

          {:error, _} ->
            new_state = generate_and_present_scene(game_state)
            game_loop(new_state)
        end
    end
  end

  defp generate_and_present_scene(game_state) do
    scene = StoryGenerator.generate_scene(game_state)
    new_state = GameState.set_scene(game_state, scene)

    display_scene(scene)
    new_state
  end

  defp display_scene(scene) do
    IO.puts("\n📖 " <> scene.description)
    IO.puts("\nWhat do you do?\n")

    scene.choices
    |> Enum.with_index()
    |> Enum.each(fn {choice, index} ->
      success_indicator = format_success_chance(choice.success_chance)
      IO.puts("  #{index + 1}. #{choice.text} #{success_indicator}")
    end)
  end

  defp format_success_chance(chance) when chance >= 75, do: "✓✓"
  defp format_success_chance(chance) when chance >= 50, do: "✓"
  defp format_success_chance(_), do: "⚠"

  defp prompt_for_action do
    IO.puts("\nEnter choice number, 's' for status, or 'q' to quit:")
    input = IO.gets("> ") |> String.trim()

    case input do
      "q" ->
        :quit

      "s" ->
        :status

      "" ->
        :continue

      num ->
        case Integer.parse(num) do
          {n, _} when n > 0 -> {:choose, n - 1}
          _ -> :continue
        end
    end
  end

  defp display_status(game_state) do
    IO.puts("\n" <> String.duplicate("=", 60))
    IO.puts("CHARACTER STATUS")
    IO.puts(String.duplicate("=", 60))

    IO.puts("Name: #{game_state.player.name}")
    IO.puts("\nAttributes:")

    Enum.each(game_state.player.attributes, fn {key, value} ->
      IO.puts("  #{key}: #{value}")
    end)

    IO.puts("\nSkills: #{format_list(game_state.player.skills)}")
    IO.puts("Inventory: #{format_list(game_state.player.inventory)}")

    IO.puts("\nWorld State:")
    IO.puts("  Day #{game_state.world.time.day}, Hour #{game_state.world.time.hour}")
    IO.puts("  Weather: #{game_state.world.weather}")
    IO.puts("  Reputation: #{game_state.world.global_state.reputation}")

    if length(game_state.story_history) > 0 do
      IO.puts("\nRecent Events:")

      game_state.story_history
      |> Enum.take(5)
      |> Enum.reverse()
      |> Enum.each(fn event ->
        IO.puts("  - #{event.choice}: #{event.result}")
      end)
    end

    IO.puts(String.duplicate("=", 60))
  end

  defp format_list([]), do: "none"
  defp format_list(items), do: Enum.join(items, ", ")
end
