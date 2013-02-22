module PlayHands
  def taken_cards(players)
    players.inject([]) { |taken_cards, player| taken_cards + player.hand.played_cards }
  end

  def available_cards(taken_cards)
    0.upto(51).map { |id| Card.by_id(id) }.reject { |card| taken_cards.member? card }
  end

  def leading_card_of_suit(taken_cards, suit)
    available_cards(taken_cards).select { |card| card.suit == suit }.
    max { |card_1, card_2| card_1 <=> card_2 }
  end

  def leading?(card, suit, taken_cards, trump)
    ((card.suit == suit or suit == :first_turn) and
      card == leading_card_of_suit(taken_cards, card.suit)) or card.suit == trump
  end

  def all_leading_cards(taken_cards, suit, trump)
    select { |card| leading? card, suit, taken_cards, trump }
  end

  def permitted_cards(suit = :first_turn)
    select { |card| permitted? card, suit }
  end

  def play(taken_cards, suit, trump)
    chance_to_win = permitted_cards(suit) & all_leading_cards(taken_cards, suit, trump)
    if chance_to_win.empty?
      worst_permitted_card suit
    else
      chance_to_win[0]
    end
  end
end