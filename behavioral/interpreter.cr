# The interpreter pattern is a design pattern that is useful when developing
# domain-specific languages or notations. The pattern allows the grammar for
# such a notation to be represented in an object-oriented fashion
# that can easily be extended.
#
# In this example, we parse a sequence of Button presses
# into a stream of moves. Nil is used to represent no press,
# ending the combo.

enum Fighter
  LiuKang
  Reptile
  Jax
end

struct Context
  property fighter : Fighter
  property buttons : Array(Button)
  property moves : Array(Move)

  def initialize(@fighter, @buttons = [] of Button, @moves = [] of Move)
  end
end

@[Flags]
enum Button
  Left
  Right
  Up
  Down
  HighKick
  LowKick
  HighPunch
  LowPunch
  Block
end

enum Move
  Back         =   1
  Forward      =   2
  Up           =   4
  Down         =   8
  HighKick     =  16
  LowKick      =  32
  HighPunch    =  64
  LowPunch     = 128
  Block        = 256
  HighFireball
  AcidSpit
  EnergyBlast
end

abstract class Evaluator
  def initialize(@context)
  end

  abstract def evaluate(press)

  protected getter context : Context
end

class TerminalExpression < Evaluator
  def evaluate(_press)
    if special_move
      context.moves << special_move.as(Move)
    else
      context.moves = context.moves + regular_moves
    end

    context.tap {|c| c.buttons = [] of Button }
  end

  private def special_move
    case context.buttons
    when .== [Button::Right, Button::Right, Button::HighPunch]
      case context.fighter
      when Fighter::LiuKang
        Move::HighFireball
      when Fighter::Reptile
        Move::AcidSpit
      else
        nil
      end
    when .== [Button::Down, Button::Left, Button::HighKick]
      case context.fighter
      when Fighter::Jax
        Move::EnergyBlast
      else
        nil
      end
    else
      nil
    end
  end

  private def regular_moves
    context.buttons.map { |b| Move.from_value(b.to_i) }
  end
end

class PressExpression < Evaluator
  def evaluate(press)
    context.tap { |c| c.buttons << press }
  end
end

alias Input = Array(Int32?)

class Parser
  def parse(sequence : Input, fighter) : Array(Move)
    presses = sequence.map do |press|
      press ? Button.from_value?(press.as(Int32)) : nil
    end

    context = Context.new(fighter: fighter)

    evaluate(presses, context)
  end

  def evaluate(presses, context)
    final_context = presses.reduce(context) do |current_context, press|
      case press
      when .nil?
        TerminalExpression.new(current_context).evaluate(press)
      else
        PressExpression.new(current_context).evaluate(press)
      end
    end

    final_context.moves
  end
end

MOVE_LIST = [
  [16, nil],
  [2, 2, 64, nil],
  [8, 1, 16, nil, 32, nil]
]

parser = Parser.new

puts parser.parse sequence: MOVE_LIST[0], fighter: Fighter::LiuKang  # => [HighKick]
puts parser.parse sequence: MOVE_LIST[0], fighter: Fighter::Reptile  # => [HighKick]
puts parser.parse sequence: MOVE_LIST[1], fighter: Fighter::LiuKang  # => [HighFireball]
puts parser.parse sequence: MOVE_LIST[1], fighter: Fighter::Reptile  # => [AcidSpit]
puts parser.parse sequence: MOVE_LIST[1], fighter: Fighter::Jax      # => [Forward, Forward, HighPunch]
puts parser.parse sequence: MOVE_LIST[2], fighter: Fighter::Jax      # => [EnergyBlast, LowKick]
puts parser.parse sequence: MOVE_LIST[2], fighter: Fighter::Reptile  # => [Down, Back, HighKick, LowKick]
