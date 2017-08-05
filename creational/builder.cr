# Separates object construction from its representation.
# Separate the construction of a complex object from its representation
# so that the same construction processes can create different representations.

class StageBuilder
  getter stage

  def initialize(name, width, height)
    @stage = Stage.new(name)
    @stage.width = width
    @stage.height = height
    @stage.brutalities = [] of Brutality
  end

  def set_background(background)
    @stage.background = background
  end

  def add_brutality(brutality)
    @stage.add_brutality brutality
  end
end

class Stage
  getter name : String
  property width, height
  property background : Background?
  property brutalities = [] of Brutality

  def initialize(@name, @width = 800, @height = 600)
  end

  def add_brutality(brutality : Brutality)
    brutalities << brutality
  end
end

class Brutality; end

class Background; end

builder = StageBuilder.new("Dead Pool", 800, 600)
builder.set_background(Background.new)
builder.add_brutality(Brutality.new)
builder.add_brutality(Brutality.new)

stage = builder.stage
puts stage.name, stage.width, stage.height, stage.brutalities.size
# Dead Pool
# 800
# 600
# 2
