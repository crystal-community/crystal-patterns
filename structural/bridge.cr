# Defines a manner for creating relationships between classes or entities.
# The bridge pattern is used to separate the abstract elements of a class
# from the implementation details.

abstract class GraphicsBackend
  abstract def draw(scene)
end

class OpenGL < GraphicsBackend
  def draw(scene)
    puts "Drawing scene using OpenGL backend. Tick: #{scene.timer}"
  end
end

class Direct3D < GraphicsBackend
  def draw(scene)
    puts "Drawing scene using Direct3D backend. Tick: #{scene.timer}"
  end
end

abstract class Scene
  getter graphics : GraphicsBackend

  def initialize(@graphics)
  end

  abstract def repaint
end

class FightingScene < Scene
  getter timer

  def initialize(@graphics)
    super(@graphics)

    @timer = 0
  end

  def repaint
    @graphics.draw(self)
  end

  def refresh_fight_timer
    @timer += 1
  end
end

scenes = [] of Scene
scenes << FightingScene.new(OpenGL.new)
scenes << FightingScene.new(Direct3D.new)

scenes.each do |scene|
  3.times do
    scene.refresh_fight_timer
    scene.repaint
  end
end

# Drawing scene using OpenGL backend. Tick: 1
# Drawing scene using OpenGL backend. Tick: 2
# Drawing scene using OpenGL backend. Tick: 3

# Drawing scene using Direct3D backend. Tick: 1
# Drawing scene using Direct3D backend. Tick: 2
# Drawing scene using Direct3D backend. Tick: 3
