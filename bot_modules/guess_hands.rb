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