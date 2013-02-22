class Player
  attr_accessor :hand, :name, :score

  def initialize(name)
    @name = name
    @hand = []
  end

  def to_s
    name
  end

  def ==(other)
    self.name == other.name
  end
end