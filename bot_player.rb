require './ohio.rb'
require './bot_modules/guess_hands.rb'
require './bot_modules/play_hands.rb'

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

  def play_card(suit = :first_turn, cards_on_table)
    taken_cards = hand.taken_cards cards_on_table.players
    choice = hand.play(taken_cards, cards_on_table.suit, cards_on_table.trump)
    hand.take_card choice
    puts "Bot plays #{choice}"
    CardOnTable.new choice.suit, choice.value, self
  end
end