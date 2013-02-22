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