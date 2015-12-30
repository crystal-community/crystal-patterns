# Defines a link between objects so that when one object's state
# changes, all dependent objects are update automatically. Allows
# communication between objects in a loosely coupled manner.

module Observable(T)
  getter observers

  def add_observer(observer)
    @observers ||= [] of T
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
  abstract def update(fighter)
end

class Stats < Observer
  def update(fighter)
    puts "Updating stats: #{fighter.name}'s health is #{fighter.health}"
  end
end

class DieAction < Observer
  def update(fighter)
    puts "#{fighter.name} is dead. Fight is over!" if fighter.is_dead?
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
# Scorpion is dead. Fight is over!
