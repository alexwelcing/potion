defmodule Potion.CharacterTest do
  use ExUnit.Case

  test "creates a new character with default attributes" do
    character = Potion.Character.new("TestHero")
    assert character.name == "TestHero"
    assert character.attributes.strength == 10
    assert character.attributes.intelligence == 10
    assert character.skills == []
    assert character.inventory == []
  end

  test "modifies character attributes" do
    character = Potion.Character.new("Hero")
    modified = Potion.Character.modify_attribute(character, :strength, 5)
    assert modified.attributes.strength == 15
  end

  test "adds items to inventory" do
    character = Potion.Character.new("Hero")
    with_item = Potion.Character.add_item(character, "sword")
    assert "sword" in with_item.inventory
  end

  test "learns new skills" do
    character = Potion.Character.new("Hero")
    with_skill = Potion.Character.learn_skill(character, "combat")
    assert "combat" in with_skill.skills
  end

  test "doesn't duplicate skills" do
    character = Potion.Character.new("Hero")
    character = Potion.Character.learn_skill(character, "magic")
    character = Potion.Character.learn_skill(character, "magic")
    assert length(character.skills) == 1
  end

  test "updates relationships" do
    character = Potion.Character.new("Hero")
    updated = Potion.Character.update_relationship(character, "Mentor", 10)
    assert updated.relationships["Mentor"] == 10
  end
end
