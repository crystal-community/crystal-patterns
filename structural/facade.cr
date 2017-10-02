# The facade pattern is a design pattern that is used to simplify access
# to functionality in complex or poorly designed subsystems.
# The facade class provides a simple, single-class interface that hides
# the implementation details of the underlying code.

# ----------------- Complex or poorly designed library -----------------------
class Arena
  @round : Round?

  property round

  def initialize(@name : String)
    load_arena(@name)
  end

  def load_arena(name : String)
    puts "Loading arena #{name} from disk..."
  end
end

class RoundManager
  def define_round(arena : Arena, round_params : RoundParams)
    check_round_params(round_params)
    arena.round = Round.create_with_params(round_params)
  end

  def check_round_params(params : RoundParams)
    puts "Checking validity of round parameters..."
  end
end

class Round
  def initialize(@time : Int32, @matches : Int32)
    puts "Round initialized with duration #{@time}s and #{@matches} matches."
  end

  def self.create_with_params(params : RoundParams)
    Round.new(params.time, params.matches)
  end
end

struct RoundParams
  property time, matches

  def initialize(@time : Int32, @matches : Int32)
  end
end

# ----------------------------------------------------------------------------

# Facade provides simplified access to the complex API
class Facade
  DEFAULT_TIME    = 60
  DEFAULT_MATCHES =  3

  def self.create_default_arena : Arena
    arena = Arena.new("default")
    rm = RoundManager.new
    params = RoundParams.new(DEFAULT_TIME, DEFAULT_MATCHES)
    rm.define_round(arena, params)
    arena
  end
end

Facade.create_default_arena
# Loading arena default from disk...
# Checking validity of round parameters...
# Round initialized with duration 60s and 3 matches.
