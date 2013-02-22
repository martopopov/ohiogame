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