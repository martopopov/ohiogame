class TableHand
  def play
    if @count_cards < 4
      new_card_hand(players[0].play_card(@suit, self)).play
    else self
    end
  end
end