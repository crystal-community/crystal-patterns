# Class which can have only one instance.
# Provides a global point to this instance.

class Game
  getter name

  @@instance = new

  def initialize
    @name = "Mortal Kombat"
  end

  def self.instance
    return @@instance
  end
end

puts Game.instance.name
# Mortal Kombat
