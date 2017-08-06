# Defines a manner for creating relationships between classes or entities.
# The decorator pattern is used to extend or alter the functionality of objects
# at run-time by wrapping them in an object of a decorator class.
# This provides a flexible alternative to using inheritance to modify behaviour.

abstract class Fighter
  abstract def power
  abstract def abilities
end

class Scorpion < Fighter
  def power
    25.0
  end

  def abilities
    %w(hellfire shuriken)
  end
end

class FighterAbility < Fighter
  getter fighter : Fighter

  def initialize(@fighter)
  end

  def power
    fighter.power
  end

  def abilities
    fighter.abilities
  end
end

class Spear < FighterAbility
  def power
    super + 10
  end

  def abilities
    super << "spear"
  end
end

class LegTakedown < FighterAbility
  def power
    super + 15
  end

  def abilities
    super << "leg takedown"
  end
end

class FireBall < FighterAbility
  def power
    super + 25
  end

  def abilities
    super << "fire ball"
  end
end

scorpion = Scorpion.new
pp scorpion.power, scorpion.abilities
# scorpion.power     # => 25.0
# scorpion.abilities # => ["hellfire", "shuriken"]

scorpion = Spear.new(scorpion)
pp scorpion.power, scorpion.abilities
# scorpion.power     # => 35.0
# scorpion.abilities # => ["hellfire", "shuriken", "spear"]

scorpion = LegTakedown.new(scorpion)
pp scorpion.power, scorpion.abilities
# scorpion.power     # => 50.0
# scorpion.abilities # => ["hellfire", "shuriken", "spear", "leg takedown"]

scorpion = FireBall.new(scorpion)
pp scorpion.power, scorpion.abilities
# scorpion.power     # => 75.0
# scorpion.abilities # => ["hellfire", "shuriken", "spear", "leg takedown", "fire ball"]
