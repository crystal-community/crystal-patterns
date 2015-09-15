# The iterator pattern is a design pattern that provides a means for
# the elements of an aggregate object to be accessed sequentially without
# knowledge of its structure. This allows traversing of lists, trees and
# other structures in a standard manner.

class Fighter
  getter name, weight

  def initialize(@name, @weight)
  end
end

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
