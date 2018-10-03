# The mediator pattern is a design pattern that promotes loose coupling of objects
# by removing the need for classes to communicate with each other directly.
# Instead, mediator objects are used to encapsulate and centralise the
# interactions between classes.

enum Move
  Die   = -1
  Block =  0
  Kick  = 10
  Punch = 30
end

abstract class MediatorBase
  abstract def perform_move(move, performer)
end

abstract class ColleagueBase
  protected getter mediator : MediatorBase

  def initialize(@mediator)
    @mediator.register(self)
  end

  def send(move : Move)
    mediator.perform_move(move, self)
  end

  def receive(move, sender)
    handle_move(move, sender)
  end

  abstract def handle_move(move, fighter)
end

class Match < MediatorBase
  property player1 : Fighter?
  property player2 : Fighter?

  def initialize
    puts "New match created"
  end

  def register(fighter : Fighter)
    if player1.nil?
      puts "Player 1: #{fighter.name}"
      self.player1 = fighter
    elsif player2.nil?
      puts "Player 2: #{fighter.name}"
      self.player2 = fighter
    else
      raise "Game already full"
    end
  end

  def perform_move(move, fighter)
    if can_perform_move?(move, fighter)
      if (fighter == player1)
        player2.as(Fighter).receive(move, fighter)
      elsif (fighter == player2)
        player1.as(Fighter).receive(move, fighter)
      else
        # not a player in this match
      end
    else
      puts "Ignoring move"
    end
  end

  private def can_perform_move?(move, fighter)
    two_players? &&
      playing?(fighter) &&
      can_perform?(move, fighter)
  end

  private def two_players?
    !(player1.nil? || player2.nil?)
  end

  private def playing?(fighter)
    !fighter.nil? && [player1, player2].includes? fighter
  end

  private def can_perform?(move, fighter)
    (move == Move::Die) || everyone_alive?
  end

  private def everyone_alive?
    player1.as(Fighter).alive? && player2.as(Fighter).alive?
  end
end

class Fighter < ColleagueBase
  property name : String

  def initialize(@mediator, @name)
    super(@mediator)
    @health_bar = 100_i8
  end

  def alive?
    @health_bar > 0
  end

  def kick
    puts "#{name} kicks"
    send(Move::Kick)
  end

  def punch
    puts "#{name} punches"
    send(Move::Punch)
  end

  def block
    puts "#{name} blocks"
    send(Move::Block)
  end

  def die
    puts "#{name} died"
    send(Move::Die)
  end

  def handle_move(move, fighter)
    if fighter != self
      value = move.value
      case move
      when Move::Die
        puts "#{name} defeated #{fighter.name}!"
      else
        if value > 0
          @health_bar -= move.to_i
          puts "#{name} is damaged for #{value} (#{@health_bar})"
        end
      end
      if @health_bar < 0
        self.die
      end
    end
  end
end

match = Match.new

p1 = Fighter.new(match, name: "Liu Kang")
p1.punch

p2 = Fighter.new(match, name: "Shang Tsung")

p1.kick
p2.punch
p1.kick
p2.punch
p1.punch
p1.punch
p2.kick
p1.punch
p1.kick
