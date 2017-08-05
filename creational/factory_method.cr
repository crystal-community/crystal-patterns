# Used to replace class constructors, abstracting the process of object generation
# so that the type of the object instantiated can be determined at run-time.

abstract class Fighter
  getter name : String

  def initialize(@name)
  end

  def fullname
    "#{@name} (#{self.class})"
  end
end

class Human < Fighter
end

class God < Fighter
end

class Kiborg < Fighter
end

class Wampire < Fighter
end

class Tournament
  getter team1 = [] of Fighter
  getter team2 = [] of Fighter

  def initialize(number_of_fights = 0)
    number_of_fights.times do |i|
      @team1 << create_fighter(:team1, "Fighter ##{i + 1}")
      @team2 << create_fighter(:team2, "Fighter ##{i + 1}")
    end
  end
end

class HumansVSWampires < Tournament
  def create_fighter(team, name)
    case team
    when :team1
      Human.new(name)
    when :team2
      Wampire.new(name)
    else
      raise Exception.new "unknown team #{team}"
    end
  end
end

class KiborgsVSGods < Tournament
  def create_fighter(team, name)
    case team
    when :team1
      Kiborg.new(name)
    when :team2
      God.new(name)
    else
      raise Exception.new "unknown team #{team}"
    end
  end
end

t1 = HumansVSWampires.new(2)
puts "Team1:\n #{t1.team1.map(&.fullname).join("\n ")}"
puts "Team2:\n #{t1.team2.map(&.fullname).join("\n ")}"

# Team1:
#  Fighter #1 (Human)
#  Fighter #2 (Human)
# Team2:
#  Fighter #1 (Wampire)
#  Fighter #2 (Wampire)

t2 = KiborgsVSGods.new(4)
puts "Team1:\n #{t2.team1.map(&.fullname).join("\n ")}"
puts "Team2:\n #{t2.team2.map(&.fullname).join("\n ")}"

# Team1:
#  Fighter #1 (Kiborg)
#  Fighter #2 (Kiborg)
#  Fighter #3 (Kiborg)
#  Fighter #4 (Kiborg)
# Team2:
#  Fighter #1 (God)
#  Fighter #2 (God)
#  Fighter #3 (God)
#  Fighter #4 (God)
