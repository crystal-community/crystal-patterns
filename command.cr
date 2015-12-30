# The command pattern is a design pattern that enables all of the
# information for a request to be contained within a single object.
# The command can then be invoked as required, often as part of a
# batch of queued commands with rollback capabilities.

abstract class Command
  abstract def execute
  abstract def undo
end

class MoveLeft < Command
  def execute
    puts "One step left"
  end

  def undo
    puts "Undo step left"
  end
end

class MoveRight < Command
  def execute
    puts "One step right"
  end

  def undo
    puts "Undo step right"
  end
end

class Hit < Command
  def execute
    puts "Do one hit"
  end

  def undo
    puts "Undo one hit"
  end
end

class CommandSequence < Command
  def initialize
    @commands = [] of Command
  end

  def <<(command)
    @commands << command
  end

  def execute
    @commands.each &.execute
  end

  def undo
    @commands.reverse.each &.undo
  end
end

class CommandSequencePlayer
  def initialize(@sequence : CommandSequence)
  end

  def forward
    @sequence.execute
  end

  def backward
    @sequence.undo
  end
end

# Sample
sequence = CommandSequence.new.tap do |r|
  r << MoveLeft.new
  r << MoveLeft.new
  r << MoveLeft.new
  r << Hit.new
  r << MoveRight.new
end

player = CommandSequencePlayer.new sequence

player.forward
# One step left
# One step left
# One step left
# Do one hit
# One step right

player.backward
# Undo step right
# Undo one hit
# Undo step left
# Undo step left
# Undo step left
