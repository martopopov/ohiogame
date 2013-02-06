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

class Deck
  attr_accessor :cards

  def initialize
    @cards = 0.upto(51).to_a.shuffle.map { |id| Card.by_id(id) }
  end

  def deal(round)
    0.upto(3).map do |number|
      BotHand.new cards.select { |card| cards.index(card) % 4 == number and cards.index(card) < 4 * round }
    end
  end

  def trump(round)
    round < 13 ? cards[4 * round].suit : :no_trump
  end
end

class Hand
  attr_accessor :cards
  include Enumerable

  def initialize(cards)
    @cards = Hash[[[:available, cards]]]
  end

  def each(&block)
    @cards[:available].each(&block)
  end

  def take_card(chosen_card)
    if @cards[:available].member? chosen_card
      @cards[:available].delete chosen_card
      @cards[:taken] ||= []
      @cards[:taken] << chosen_card
    end
  end

  def played_cards
    @cards[:taken] or []
  end

  def to_s
    map(&:to_s).inject { |string, card| string + ', ' + card }
  end

  def has_suit?(suit)
    any? { |card| card.suit == suit }
  end

  def has_card?(picked_card)
    any? { |card| card == picked_card }
  end

  def permitted?(card, suit = :first_turn)
    has_card? card and
    not (card.suit != suit and has_suit? suit)
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

class TableHand
  attr_accessor :players, :count_cards, :cards, :suit, :trump

  def initialize(players, trump, cards = [], count_cards = 0)
    @players = players
    @trump = trump
    @count_cards = count_cards
    @cards = cards
    @suit = (cards[0] ? cards[0].suit : :no_trump)
  end

  def new_card_hand(card)
    new_cards = @cards << card
    TableHand.new players.rotate, @trump, new_cards, @count_cards + 1
  end

  def first_turn?
    count_cards == 0
  end

  def winner
    winning_card = @cards.inject { |win_card, card| card.greater?(win_card, @trump) ? card : win_card }
    winning_card.player
  end

  def to_s
    cards.map(&:to_s).inject { |string, card| string + ', ' + card }
  end
end

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

class Round
  attr_accessor :trump, :players, :number

  def initialize(number, players)
    @number = number
    @players = players
    @hand_counts = players.each_with_object({}) { |player, hash| hash[player] = 0 }
  end

  def deal
    deck = Deck.new
    players[0].hand, players[1].hand, players[2].hand, players[3].hand = *deck.deal(number)
    @trump = deck.trump number
  end

  def ===(range)
    number === range
  end

  def new_order(players, master_player)
    players[0] == master_player ? players : new_order(players.rotate, master_player)
  end
end

class Game
  attr_accessor :score_table

  def initialize(players)
    @players = players
    @score_table = Hash[players.zip([0, 0, 0, 0])]
  end

  def update_score_table(round_score_table)
    score_table.update(round_score_table) { |player, old_score, round_score| old_score + round_score }
  end
end