# Used to instantiate a new object by copying all of the properties of
# an existing object, creating an independent clone

class Trophy
  enum Type
    Gold
    Silver
    Bronse
  end

  getter name, description, type, winner

  def initialize(@name : String, @description : String, @type : Type, @winner : String)
  end

  def _clone(new_winner : String)
    Trophy.new name,
      description,
      type,
      new_winner
  end
end

trophy = Trophy.new "Dark Future",
  "Perform 50 Brutalities.",
  Trophy::Type::Gold,
  "Noob"

trophy = trophy._clone "Liu Kang"
puts trophy.winner
# Liu Kang
