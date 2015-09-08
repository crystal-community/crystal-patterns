# Crystal patterns

Design patterns completely implemented in Crystal language.

The goal is to have a quick set of examples of [GOF patterns](http://www.blackwasp.co.uk/gofpatterns.aspx) for Crystal users.

* Creational
* Structural
* Behavioral
  - [Observer](#observer)
  - [Strategy](#strategy)
  - [Template Method](#template-method)

## Observer

Defines a link between objects so that when one object's state changes, all dependent objects are updated automatically. Allows communication between objects in a loosely coupled manner.

```crystal
module Observable(T)
  getter observers

  def add_observer(observer)
    @observers = [] of T unless @observers
    @observers.not_nil! << observer
  end

  def delete_observer(observer)
    @observers.try &.delete(observer)
  end

  def notify_observers
    @observers.try &.each &.update self
  end
end

class Fighter
  include Observable(Observer)

  getter name, health

  def initialize(@name)
    @health = 100
  end

  def damage(rate)
    if @health > rate
      @health -= rate
    else
      @health = 0
    end
    notify_observers
  end

  def is_dead?
    @health <= 0
  end
end

abstract class Observer
  abstract def update fighter
end

class Stats < Observer
  def update(fighter)
    puts "Updating stats: #{fighter.name}'s health is #{fighter.health}"
  end
end

class DieAction < Observer
  def update(fighter)
    puts "#{fighter.name} is dead. Finish him!" if fighter.is_dead?
  end
end

# Sample
fighter = Fighter.new("Scorpion")

fighter.add_observer(Stats.new)
fighter.add_observer(DieAction.new)

fighter.damage(10)
# Updating stats: Scorpion's health is 90

fighter.damage(30)
# Updating stats: Scorpion's health is 60

fighter.damage(75)
# Updating stats: Scorpion's health is 0
# Scorpion is dead. Finish him!
```
## Strategy

Allows a set of similar algorithms to be defined and encaplusated in their own classes. The algorithm to be used for a particular purpose may then be selected at run-time.

```crystal
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
```

## Template method

Defines and invariant part of the algorithm in a base class and encapsulates the variable parts in methods that are defined by a number of subclasses.

```crystal
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
```

