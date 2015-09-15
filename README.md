# Crystal patterns

Design patterns completely implemented in Crystal language.

The goal is to have a quick set of examples of [GOF patterns](http://www.blackwasp.co.uk/gofpatterns.aspx) for Crystal users.

* [Creational](#creational)
* [Structural](#structural)
  - [Composite](#composite)
* [Behavioral](#behavioral)
  - [Iterator](#iterator)
  - [Observer](#observer)
  - [Strategy](#strategy)
  - [Template Method](#template-method)

# Creational

# Structural

## Composite

The composite pattern is a design pattern that is used when creating hierarchical object models. The pattern defines a manner in which to design recursive tree structures of objects, where individual objects and groups can be accessed in the same manner

```crystal
abstract class Strike
  abstract def damage
  abstract def attack
end
```

```crystal
class Punch < Strike
  def attack
    puts "Hitting with punch"
  end

  def damage
    5
  end
end
```

```crystal
class Kick < Strike
  def attack
    puts "Hitting with kick"
  end

  def damage
    8
  end
end
```

```crystal
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
```

``` crystal
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
```

# Behavioral

## Iterator

The iterator pattern is a design pattern that provides a means for the elements of an aggregate object to be accessed sequentially without knowledge of its structure. This allows traversing of lists, trees and other structures in a standard manner.

```crystal
class Fighter
  getter name, weight

  def initialize(@name, @weight)
  end
end
```

```crystal
class Tournament
  include Enumerable(Fighter)

  def initialize
    @fighters = [] of Fighter
  end

  def << (fighter)
    @fighters << fighter
  end

  def each
    @fighters.each { |fighter| yield fighter }
  end
end
```

```crystal
# Sample
tournament = Tournament.new
  .tap(&.<< Fighter.new "Jax", 150)
  .tap(&.<< Fighter.new "Liu Kang", 84)
  .tap(&.<< Fighter.new "Liu Kang", 95)
  .tap(&.<< Fighter.new "Sub-Zero", 95)
  .tap(&.<< Fighter.new "Smoke", 252)

tournament.select { |fighter| fighter.weight > 100 }
  .map {|fighter| fighter.name}
# => ["Jax", "Smoke"]
```

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
```

```crystal
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
```

```crystal
abstract class Observer
  abstract def update fighter
end
```

```crystal
class Stats < Observer
  def update(fighter)
    puts "Updating stats: #{fighter.name}'s health is #{fighter.health}"
  end
end
```

```crystal
class DieAction < Observer
  def update(fighter)
    puts "#{fighter.name} is dead. Finish him!" if fighter.is_dead?
  end
end
```

```crystal
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
```

```crystal
abstract class FightStrategy
  HITS = {:punch => 40, :kick => 12}

  abstract def attack(fighter, opponent)
end
```

```crystal
class Puncher < FightStrategy
  def attack(ft, op)
    puts "#{ft.name} attacks #{op.name} with 1 punch."
    op.damage(HITS[:punch])
  end
end
```

```crystal
class Combo < FightStrategy
  def attack(ft, op)
    puts "#{ft.name} attacks #{op.name} with 2 kicks and 1 punch."

    op.damage(HITS[:kick])
    op.damage(HITS[:kick])
    op.damage(HITS[:punch])
  end
end
```

```crystal
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
```

```crystal
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
```

```crystal
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
```

```crystal
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
