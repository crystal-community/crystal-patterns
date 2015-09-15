# The composite pattern is a design pattern that is used when
# creating hierarchical object models. The pattern defines a
# manner in which to design recursive tree structures of objects,
# where individual objects and groups can be accessed in the same manner

abstract class Strike
  abstract def damage
  abstract def attack
end

class Punch < Strike
  def attack
    puts "Hitting with punch"
  end

  def damage
    5
  end
end

class Kick < Strike
  def attack
    puts "Hitting with kick"
  end

  def damage
    8
  end
end

class Combo < Strike
  def initialize
    @sub_strikes = [] of Strike
  end

  def << (strike)
    @sub_strikes << strike
  end

  def damage
    @sub_strikes.inject(0) { |acc, x| acc + x.damage }
  end

  def attack
    @sub_strikes.each &.attack
  end
end

# Sample
super_strike = Combo.new
  .tap(&.<< Kick.new)
  .tap(&.<< Kick.new)
  .tap(&.<< Punch.new)

super_strike.attack
# Hitting with kick
# Hitting with kick
# Hitting with punch

super_strike.damage
# => 21

