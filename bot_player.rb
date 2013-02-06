require './ohio.rb'

module GuessHands
  def low_round_guess_hands(trump)
    cards_of_suit(trump).count
  end

   def medium_round_guess_hands(trump)
     (cards_of_suit(trump) | cards_of_value('A')).count
   end

  def high_round_guess_hands(trump)
    (cards_of_suit(trump) | cards_of_value('A') | cards_of_value('K')).count
  end

  def no_trump_guess_hands
    (cards_of_value('K') | cards_of_value('A')).count
  end
end

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

class BotHand < Hand
  include GuessHands
  include PlayHands

  def cards_of_suit(suit)
    cards_of_type suit, :suit
  end

  def cards_of_value(value)
    cards_of_type value, :value
  end

  def best_card_of_suit(suit)
    extremal cards_of_suit(suit), :max
  end

  def worst_card_of_suit(suit)
    extremal cards_of_suit(suit), :min
  end

  def worst_permitted_card(suit)
    extremal permitted_cards(suit), :min
  end

  private

  def extremal(set_of_cards, type)
    set_of_cards.send(type) { |card_1, card_2| card_1 <=> card_2 }
  end

  def cards_of_type(pattern, type)
    select { |card| card.send(type) == pattern }
  end
end

class BotPlayer < Player
  def guess_hands(round)
    case round
      when (1..3) then hand.low_round_guess_hands round.trump
      when (4..7) then hand.medium_round_guess_hands round.trump
      when (8..12) then hand.high_round_guess_hands round.trump
      when (13..16) then hand.no_trump_guess_hands
    end
  end

  # def possible_cards(suit = :first_turn)
  #   select { |card| permitted? card, suit }
  # end

  def play_card(suit = :first_turn, cards_on_table)
    taken_cards = hand.taken_cards cards_on_table.players
    choice = hand.play(taken_cards, cards_on_table.suit, cards_on_table.trump)
    hand.take_card choice
    puts "Bot plays #{choice}"
    CardOnTable.new choice.suit, choice.value, self
  end
end