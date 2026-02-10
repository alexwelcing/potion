defmodule Potion do
  @moduledoc """
  Potion - An endless generative story gameplay system inspired by Fable.

  This module provides the main API for starting and managing story-driven gameplay
  with dynamic content generation, character progression, and branching narratives.

  ## Quick Start

      # Start a new game
      Potion.play("Hero")

  ## Core Concepts

  - **Character**: Players and NPCs with attributes, skills, and relationships
  - **World**: Dynamic world state with locations, time, and global events
  - **Story Generation**: Procedural narrative generation based on game state
  - **Choices**: Player decisions that impact character growth and story direction

  """

  alias Potion.Game

  @doc """
  Starts a new game with the given player name.

  ## Examples

      Potion.play("Arthur")

  """
  def play(player_name) when is_binary(player_name) do
    Game.start_game(player_name)
  end

  @doc """
  Creates a new game state without starting the interactive loop.
  Useful for testing or custom game implementations.

  ## Examples

      state = Potion.new_game("TestPlayer")

  """
  def new_game(player_name) do
    Potion.GameState.new(player_name)
  end
end
