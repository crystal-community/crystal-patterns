# Provides a way to encapsulate a group of individual factories that have a
# common theme without specifying their concrete classes.

abstract class Fighter
  getter name : String

  def initialize(@name)
  end
end

class Human < Fighter
end

class God < Fighter
end

abstract class Realm
end

class Earthrealm < Realm
end

class Haven < Realm
end

abstract class WorldFactory
  abstract def create_realm
  abstract def create_fighter(name)
end

class HavenFactory < WorldFactory
  def create_realm
    Haven.new
  end

  def create_fighter(name)
    God.new(name)
  end
end

class EarthrealmFactory < WorldFactory
  def create_realm
    Earthrealm.new
  end

  def create_fighter(name)
    Human.new(name)
  end
end

class World
  @realm : Realm
  @fighters = [] of Fighter

  def initialize(factory, number_of_fighters)
    @realm = factory.create_realm

    number_of_fighters.times do |i|
      @fighters << factory.create_fighter("Fighter ##{i + 1}")
    end
  end

  def all_fighters
    @fighters.map do |fighter|
      fighter.name + " from #{@realm.class}"
    end
  end
end

haven = World.new(HavenFactory.new, 2)
puts haven.all_fighters
# ["Fighter #1 from Haven", "Fighter #2 from Haven"]

earthrealm = World.new(EarthrealmFactory.new, 3)
puts earthrealm.all_fighters
# ["Fighter #1 from Earthrealm", "Fighter #2 from Earthrealm", "Fighter #3 from Earthrealm"]
