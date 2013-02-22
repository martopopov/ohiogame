class Round
  def annoucement
    deal
    puts "the trump is #{trump}"
    players.each_with_object({}) do |player, hash|
      hash[player] = player.guess_hands self
    end
  end

  def play
    @hand_predictions = annoucement
    play_hand TableHand.new(players, @trump), number
  end

  def play_hand(table_hand, number)
    if number != 0
      table_hand.play
      master_player = table_hand.winner
      @hand_counts[master_player] += 1
      play_hand TableHand.new(new_order(@players, master_player), @trump), number - 1
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