# The visitor pattern is a design pattern that separates a set of
# structured data from the functionality that may be performed upon it.
# This promotes loose coupling and enables additional operations
# to be added without modifying the data classes.

# Base Visitor class. Defines abstract operations on all visitable classes
abstract class Visitor
  abstract def visit(fighter : Fighter)
  abstract def visit(arena : Arena)
end

# Concrete Visitor implementations, performing different tasks on
# visitable objects.
class SetupVisitor < Visitor
  def visit(fighter : Fighter)
    puts "[Setup] Visiting Fighter"
    fighter.ready
  end

  def visit(arena : Arena)
    puts "[Setup] Visiting Arena"
    arena.prepare
  end
end

class UpdateVisitor < Visitor
  def visit(fighter : Fighter)
    puts "[Update] Visiting Fighter"
    fighter.is_ko = fighter.hp == 0
  end

  def visit(arena : Arena)
    puts "[Update] Visiting Arena"
    puts("Battle is over!") if arena.destroyed?
  end
end

# Base visitable class. Defines an abstract "accept" method.
abstract class GameElement
  abstract def accept(visitor : Visitor)
end

# Visitable classes. These classes just pass themselves to the visitor
# in their accept method.
class Fighter < GameElement
  property hp, is_ko

  def initialize
    @ready_for_battle = false
    @hp = 100
    @is_ko = false
  end

  def ready
    @ready_for_battle = true
    puts "Fighter is ready!"
  end

  def accept(visitor : Visitor)
    visitor.visit(self)
  end
end

class Arena < GameElement
  def initialize
    @destroyed = false
  end

  def prepare
    puts "Preparing arena..."
  end

  def destroyed?
    @destroyed
  end

  def accept(visitor : Visitor)
    visitor.visit(self)
  end
end

arena = Arena.new
fighter = Fighter.new
setup_visitor = SetupVisitor.new
update_visitor = UpdateVisitor.new

# We can store different GameElements in a common Array(GameElements)
# and have the Visitors call the proper overloaded method thanks to the
# double dispatch provided by their `accept` methods.
game_elements = [arena, fighter]

game_elements.each { |elem| elem.accept(setup_visitor) }
3.times do
  game_elements.each { |elem| elem.accept(update_visitor) }
end

# [Setup] Visiting Arena
# Preparing arena...
# [Setup] Visiting Fighter
# Fighter is ready!
# [Update] Visiting Arena
# [Update] Visiting Fighter
# [Update] Visiting Arena
# [Update] Visiting Fighter
# [Update] Visiting Arena
# [Update] Visiting Fighter
