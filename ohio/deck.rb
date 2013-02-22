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