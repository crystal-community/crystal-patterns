# Defines and invariant part of the algorithm in a base class
# and encapsulates the variable parts in methods that are
# defined by a number of subclasses.

abstract class Fighter
  abstract def damage_rate
  abstract def attack_message

  setter health
  getter health, name

  def initialize(@name)
    @damage_rate = damage_rate
    @attack_message = attack_message
    @health = 100
  end

  def attack(fighter)
    fighter.damage(@damage_rate)
    puts "#{@name} attacks #{fighter.name} saying '#{@attack_message}'"
    puts "#{fighter.name} is dead." if fighter.is_dead?
  end

  def is_dead?
    @health <= 0
  end

  def damage(rate)
    if @health > rate
      @health -= rate
    else
      @health = 0
    end
  end
end

class Scorpion < Fighter
  def initialize()
    super("Scorpion")
  end

  def damage_rate
    30
  end

  def attack_message
    "Vengeance will be mine."
  end
end

class Noob < Fighter
  def initialize()
    super("Noob")
  end

  def damage_rate
    50
  end

  def attack_message
    "Fear me!"
  end
end

# Sample
scor = Scorpion.new
noob = Noob.new

noob.attack scor
# Noob attacks Scorpion saying 'Fear me!'

scor.attack noob
# Scorpion attacks Noob saying 'Vengeance will be mine.'

noob.attack scor
# Noob attacks Scorpion saying 'Fear me!'
# Scorpion is dead.
