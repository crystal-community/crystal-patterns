# Class which can have only one instance.
# Provides a global point to this instance.

class Game
  getter name

  # @@instance = new

  # Game.new be prohibited outer.
  private def initialize
    @name = "Mortal Kombat"
  end

  # lazy instantiation
  def self.instance
    @@instance ||= new
  end
end

puts Game.instance.name

# private method 'new' called for Game:Class
# game = Game.new
# Mortal Kombat
