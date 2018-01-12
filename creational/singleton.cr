# Class which can have only one instance.
# Provides a global point to this instance.

class Game
  getter name

  private def initialize
    @name = "Mortal Kombat"
  end

  def self.instance
    @@instance ||= new
  end
end

puts Game.instance.name # => Mortal Kombat
