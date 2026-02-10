defmodule Potion.World do
  @moduledoc """
  Represents the game world state, including locations, NPCs, and global events.
  """

  defstruct [
    :locations,
    :npcs,
    :time,
    :weather,
    :global_state
  ]

  @type t :: %__MODULE__{
          locations: map(),
          npcs: list(Potion.Character.t()),
          time: map(),
          weather: String.t(),
          global_state: map()
        }

  @doc """
  Creates a new world with default starting state.
  """
  def new do
    %__MODULE__{
      locations: initialize_locations(),
      npcs: [],
      time: %{day: 1, hour: 8, season: "spring"},
      weather: "clear",
      global_state: %{reputation: 0, major_events: []}
    }
  end

  @doc """
  Advances world time.
  """
  def advance_time(world, hours \\ 1) do
    new_hour = rem(world.time.hour + hours, 24)
    day_change = div(world.time.hour + hours, 24)
    new_day = world.time.day + day_change

    new_time = %{world.time | hour: new_hour, day: new_day}
    %{world | time: new_time}
  end

  @doc """
  Adds an NPC to the world.
  """
  def add_npc(world, npc) do
    %{world | npcs: [npc | world.npcs]}
  end

  @doc """
  Updates global reputation.
  """
  def update_reputation(world, change) do
    new_global_state =
      Map.update!(world.global_state, :reputation, &(&1 + change))

    %{world | global_state: new_global_state}
  end

  defp initialize_locations do
    %{
      "village" => %{
        name: "Village Square",
        description: "A bustling village square with merchants and travelers.",
        connections: ["forest", "tavern"]
      },
      "forest" => %{
        name: "Dark Forest",
        description: "A mysterious forest filled with ancient trees and hidden paths.",
        connections: ["village", "ruins"]
      },
      "tavern" => %{
        name: "The Golden Tankard",
        description: "A warm tavern where stories and ale flow freely.",
        connections: ["village"]
      },
      "ruins" => %{
        name: "Ancient Ruins",
        description: "Crumbling stone structures from a forgotten age.",
        connections: ["forest"]
      }
    }
  end
end
