# Defines and invariant part of the algorithm in a base class
# and encapsulates the variable parts in methods that are
# defined by a number of subclasses.

abstract class Fighter

  abstract def damage_rate
  abstract def attack_message
  abstract def fighting_styles

  setter health
  getter health, name

  getter name

  def initialize(@position, @name)
    @damage = damage_rate
    @attack_message = attack_message
    @health = 100
  end

  def move_to(pos)
    side = @position < pos ? :right : :left
    while (@position != pos)
      move(side)
    end
  end

  def attack(fighter)
    puts String.build do |s|
      s << "#{@name} damages #{fighter.name}"
      s << " with #{@damage}"
      s << " saying '#{@attack_message}'"
    end

    if (fighter.health - @damage <= 0)
      puts "#{name} win. Finish him!"
    else
      fighter.health -= @damage
    end
  end

  private def move(side)
    case side
    when :left
      puts "#{name} moving 1 step left"
      @position -= 1
    when :right
      puts "#{name} moving 1 step right"
      @position += 1
    else
      raise "Unknown side to move to: #{side}"
    end
  end
end

class Scorpion < Fighter
  def initialize(position)
    super(position, "Scorpion")
  end

  def fighting_styles
    ["Hapkido", "Moi Fah", "Pi Gua"]
  end

  def damage_rate
    30
  end

  def attack_message
    "Vengeance will be mine."
  end
end

class Noob < Fighter
  def initialize(position)
    super(position, "Noob")
  end

  def fighting_styles
    ["Monkey"]
  end

  def damage_rate
    50
  end

  def attack_message
    "Fear me!"
  end
end

scor = Scorpion.new 2
noob = Noob.new 6

noob.move_to 4
scor.move_to 4

noob.attack(scor)
scor.attack(noob)
noob.attack(scor)
