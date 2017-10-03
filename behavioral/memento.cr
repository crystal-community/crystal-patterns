# The memento pattern is a design pattern that permits the current state
# of an object to be stored without breaking the rules of encapsulation.
# The originating object can be modified as required but can be restored
# to the saved state at any time.

# The class whose state can be saved with a memento
class Match
  def initialize(fighter1, fighter2, rounds, time)
    @state = State.new({fighter1, fighter2}, rounds, time)
  end

  def save_memento
    @state
  end

  def restore_memento(memento : Match::State)
    @state = memento
  end

  def start
    print "Starting fight between #{@state.fighters[0]} and #{@state.fighters[1]}!"
    puts " (#{@state.rounds} rounds of #{@state.time.total_seconds} seconds)"
  end

  def rounds=(rounds)
    @state.rounds = rounds
  end

  def fighters=(fighters)
    @state.fighters = fighters
  end

  # The memento class. This is an opaque class for the client.
  struct State
    getter fighters, rounds, time
    protected setter fighters, rounds, time

    def initialize(
                   @fighters : Tuple(String, String),
                   @rounds : Int32,
                   @time : Time::Span)
    end
  end
end

match = Match.new("Liu Kang", "Kano", 3, 60.seconds)
# Save the current state
previous_match_state = match.save_memento
# Change the state
match.rounds = 5
match.fighters = {"Sonya Blade", "Goro"}
match.start
# Restore the previous state
match.restore_memento(previous_match_state)
match.start

# Starting fight between Sonya Blade and Goro! (5 rounds of 60.0 seconds)
# Starting fight between Liu Kang and Kano! (3 rounds of 60.0 seconds)
