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