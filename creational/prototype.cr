# Used to instantiate a new object by copying all of the properties of
# an existing object, creating an independent clone

class Trophy
  enum Type
    Gold
    Silver
    Bronse
  end

  property name, description, type, winner

  def initialize(@name : String, @description : String, @type : Type, @winner : String)
  end

  def_clone
end

trophy_1 = Trophy.new "Dark Future",
  "Perform 50 Brutalities.",
  Trophy::Type::Gold,
  "Noob"

trophy_2 = trophy_1.clone
trophy_2.winner = "Liu Kang"

puts trophy_1.winner # => Noob
puts trophy_2.winner # => Liu Kang
