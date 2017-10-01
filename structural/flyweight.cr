# The flyweight pattern is a design pattern that is used to minimise
# resource usage when working with very large numbers of objects.
# When creating many thousands of identical objects, stateless flyweights
# can lower the memory used to a manageable level.

alias Position = {Int32, Int32}

# Contains the extrinsic actions that the object can do.
abstract class FlyweightTree
  abstract def draw_at(pos : Position)
end

# Implements the Flyweight interface, optionally keeping an extrinsic state
# which can be manipulated via that interface.
class Tree < FlyweightTree
  property pos

  def initialize(species : String)
    # Intrinsic (stateless) properties. These are shared between all instances of this tree.
    @species = species
    # Estrinsic (stateful) properties. These are accessed via the abstract interface
    # provided by FlyweightTree
    @pos = {0, 0}
  end

  def draw_at(_pos : Position)
    pos = _pos
    puts "Drawing #{@species} at #{pos}"
  end
end

# Factory class for the flyweight objects.
class Forest
  def initialize
    @trees = {} of String => FlyweightTree
  end

  def get_tree(species : String)
    if @trees.has_key?(species)
      return @trees[species]
    else
      tree = Tree.new(species)
      @trees[species] = tree
      return tree
    end
  end

  def tot_instances
    @trees.size
  end
end

# Client code
forest = Forest.new
forest.get_tree("birch").draw_at({5, 6})
forest.get_tree("acacia").draw_at({3, 1})
forest.get_tree("magnolia").draw_at({15, 86})
forest.get_tree("birch").draw_at({8, 15})
forest.get_tree("acacia").draw_at({18, 4})
forest.get_tree("baobab").draw_at({1, 41})
forest.get_tree("magnolia").draw_at({80, 50})
forest.get_tree("acacia").draw_at({22, 3})
forest.get_tree("birch").draw_at({1, 42})
forest.get_tree("baobab").draw_at({15, 7})
forest.get_tree("acacia").draw_at({33, 49})
forest.get_tree("magnolia").draw_at({0, 0})
puts "-----------------------"
puts "Total instances created: #{forest.tot_instances}"
