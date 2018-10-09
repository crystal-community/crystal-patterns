# The chain of responsibility pattern is a design pattern that defines a
# linked list of handlers, each of which is able to process requests.
# When a request is submitted to the chain, it is passed to the first
# handler in the list that is able to process it.

BATTLE_PLAN = %w(
  Scorpion
  Mileena
  Baraka
  Jax
  Johnny Cage
  Kitana
  Liu\ Kang
  Reptile
  Subzero
  Raiden
  Kung\ Lao
  Shang\ Tsung
  Kintaro
  Shao\ Khan
).reverse

class NoMoreOpponents < Exception; end

class Fighter
  getter name : String
  getter successor : Fighter?

  def initialize(@name, @successor)
    @alive = true
  end

  def defeat
    if @alive
      @alive = false
      puts "Defeated #{name}"
    elsif successor
      successor.as(Fighter).defeat
    else
      raise NoMoreOpponents.new "All opponents defeated!"
    end
    self
  end
end

struct Player
  getter name : String
  getter opponent : Fighter

  def initialize(@name, @opponent)
    @victorious = false
  end

  def fight
    puts "Fight!"
    opponent.defeat
  rescue NoMoreOpponents
    puts "#{name} Wins!"
    @victorious = true
  end

  def victorious?
    @victorious
  end
end

first_opponent = BATTLE_PLAN.reduce(nil) do |next_fighter, this_fighter|
  Fighter.new(this_fighter, next_fighter)
end.as(Fighter)

player = Player.new("Subzero", first_opponent)

until player.victorious?
  player.fight
end

# Fight!
# Defeated Scorpion
# Fight!
# Defeated Mileena
# Fight!
# Defeated Baraka
# Fight!
# Defeated Jax
# Fight!
# Defeated Johnny Cage
# Fight!
# Defeated Kitana
# Fight!
# Defeated Liu Kang
# Fight!
# Defeated Reptile
# Fight!
# Defeated Subzero
# Fight!
# Defeated Raiden
# Fight!
# Defeated Kung Lao
# Fight!
# Defeated Shang Tsung
# Fight!
# Defeated Kintaro
# Fight!
# Defeated Shao Khan
# Fight!
# Subzero Wins!
