# Allows a set of similar algorithms to be defined and encaplusated
# in their own classes. The algorithm to be used for a particular
# purpose may then be selected at run-time.

class Fighter

  getter health, name
  setter health

  def initialize(@name, @fight_strategy)
    @health = 100
  end

  def attack(opponent)
    @fight_strategy.attack self, opponent

    puts "#{opponent.name} is dead" if opponent.is_dead?
  end

  def is_dead?
    health <= 0
  end

  def damage(rate)
    if @health - rate > 0
      @health -= rate
    else
      @health = 0
    end
  end
end

abstract class FightStrategy
  HITS = {:punch => 40, :kick => 12}

  abstract def attack(fighter, opponent)
end

class Puncher < FightStrategy
  def attack(ft, op)
    puts "#{ft.name} attacks #{op.name} with 1 punch."
    op.damage(HITS[:punch])
  end
end

class Combo < FightStrategy
  def attack(ft, op)
    puts "#{ft.name} attacks #{op.name} with 2 kicks and 1 punch."

    op.damage(HITS[:kick])
    op.damage(HITS[:kick])
    op.damage(HITS[:punch])
  end
end

# Usage example
scor = Fighter.new("Scorpion", Puncher.new)
noob = Fighter.new("Noob", Combo.new)

noob.attack scor
# Noob attacks Scorpion with 2 kicks and 1 punch.

scor.attack noob
# Scorpion attacks Noob with 1 punch.

noob.attack scor
# Noob attacks Scorpion with 2 kicks and 1 punch.
# Scorpion is dead

