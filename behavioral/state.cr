# Defines a manner for controlling communication between classes or entities.
# The state pattern is used to alter the behaviour of an object as its internal
# state changes.

class GameContext
  property state : State

  def initialize(@state)
  end

  def toggle
    @state.handle(self)
  end
end

abstract class State
  abstract def handle(context : GameContext)
end

class PauseState < State
  def handle(context : GameContext)
    puts "Pause -> Play"
    context.state = PlayState.new
  end
end

class PlayState < State
  def handle(context : GameContext)
    puts "Play -> Pause"
    context.state = PauseState.new
  end
end

initial_state = PlayState.new
context = GameContext.new initial_state

context.toggle # Play -> Pause
context.toggle # Pause -> Play
