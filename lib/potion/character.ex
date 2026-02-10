defmodule Potion.Character do
  @moduledoc """
  Represents a character in the game (player or NPC).
  """

  defstruct [
    :name,
    :attributes,
    :skills,
    :inventory,
    :relationships,
    :backstory
  ]

  @type t :: %__MODULE__{
          name: String.t(),
          attributes: map(),
          skills: list(String.t()),
          inventory: list(String.t()),
          relationships: map(),
          backstory: String.t()
        }

  @doc """
  Creates a new character with default attributes.
  """
  def new(name) do
    %__MODULE__{
      name: name,
      attributes: %{
        strength: 10,
        intelligence: 10,
        charisma: 10,
        luck: 10,
        morality: 50
      },
      skills: [],
      inventory: [],
      relationships: %{},
      backstory: ""
    }
  end

  @doc """
  Modifies a character's attribute.
  """
  def modify_attribute(character, attribute, value) do
    new_attributes = Map.update(character.attributes, attribute, value, &(&1 + value))
    %{character | attributes: new_attributes}
  end

  @doc """
  Adds an item to the character's inventory.
  """
  def add_item(character, item) do
    %{character | inventory: [item | character.inventory]}
  end

  @doc """
  Adds a skill to the character.
  """
  def learn_skill(character, skill) do
    if skill in character.skills do
      character
    else
      %{character | skills: [skill | character.skills]}
    end
  end

  @doc """
  Updates relationship with another character.
  """
  def update_relationship(character, other_name, change) do
    new_relationships = Map.update(character.relationships, other_name, change, &(&1 + change))

    %{character | relationships: new_relationships}
  end
end
