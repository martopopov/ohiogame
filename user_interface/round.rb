class Round
  attr_accessor :hand_predictions

  def visualize_deal
    @hand_predictions = {}
    deal
    players[0].guess_hands self, 0
    current_table_hand = TableHand.new(players, @trump)
    play_hand current_table_hand, number
  end


  def play_hand(table_hand, number)
    if number != 0

      if table_hand.count_cards == 3
        master_player = table_hand.winner
        @hand_counts[master_player] += 1
        master_player.play_card TableHand.new(new_order(@players, master_player), @trump), self

      else
        players[0].play_card table_hand, self
      end

    else
      (Round.new @number + 1, players.rotate).visualize_deal if @number < 16
    end
  end

  def round_score
    players.each_with_object({}) do |player, table|
      if @hand_predictions[player] == @hand_counts[player] and @hand_predictions[player] == 0 and number > 12
        table[player] = 50
      elsif @hand_predictions[player] == @hand_counts[player]
        table[player] = 10 + @hand_counts[player] ** 2
      else
        table[player] = 0
      end
    end
  end
end