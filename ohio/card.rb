class Card
  include Comparable

  attr_accessor :suit, :value
  VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  SUITS = %w(Spade Heart Club Diamond)

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def self.by_id(id)
    Card.new SUITS[id / 13], VALUES[id % 13]
  end

  def self.by_string(string)
    value, suit = *string.split
    Card.new suit, value
  end

  def <=>(other) #compares only the values
    VALUES.index(self.value) <=> VALUES.index(other.value)
  end

  def ==(other)
    self.value == other.value and self.suit == other.suit
  end

  def greater?(other, trump = :no_trump)
    if self.suit == other.suit
      (self >= other) ? true : false
    else suit == trump
    end
  end

  def to_s
    "#{value} #{suit}"
  end

  def all_cards_of_suit
    VALUES.map { |value| Card.new suit, value }
  end

  def greater_cards_same_suit
    all_cards_of_suit.select { |card| card > self }
  end
end

class CardOnTable < Card
  attr_accessor :player

  def initialize(suit, value, player)
    @suit = suit
    @value = value
    @player = player
  end
end