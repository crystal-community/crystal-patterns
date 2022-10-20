# Allows a set of similar algorithms to be defined and encaplusated
# in their own classes. The algorithm to be used for a particular
# purpose may then be selected at run-time.

class Fighter
  getter health, name
  setter health

  def initialize(@name : String, @fight_strategy : FightStrategy)
    @health = 100
  end

  def attack(opponent)
    @fight_strategy.attack self, opponent
    puts "#{opponent.name} is dead" if opponent.dead?
  end

  def dead?
    health <= 0
  end

  def damage(rate)
    if @health > rate
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
  def attack(fighter, opponent)
    puts "#{fighter.name} attacks #{opponent.name} with 1 punch."
    opponent.damage(HITS[:punch])
  end
end

class Combo < FightStrategy
  def attack(fighter, opponent)
    puts "#{fighter.name} attacks #{opponent.name} with 2 kicks and 1 punch."

    opponent.damage(HITS[:kick])
    opponent.damage(HITS[:kick])
    opponent.damage(HITS[:punch])
  end
end

# Sample
scor = Fighter.new("Scorpion", Puncher.new)
noob = Fighter.new("Noob", Combo.new)

noob.attack scor
# Noob attacks Scorpion with 2 kicks and 1 punch.

scor.attack noob
# Scorpion attacks Noob with 1 punch.

noob.attack scor
# Noob attacks Scorpion with 2 kicks and 1 punch.
# Scorpion is dead
