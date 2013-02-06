require './bot_player.rb'

class TableHand
  def play
    if @count_cards < 4
      new_card_hand(players[0].input_card(@suit, self)).play
    else self
    end
  end
end

class PersonPlayer < Player
   def guess_hands(round)
    puts "#{name}, guess how many hands will you make\n"
    puts "your hand is #{hand}"
    prediction = gets("\n")
    prediction.to_i
  end

  def input_card(suit = :first_turn, cards_on_table)
    puts "#{name}, it's your turn\n"
    puts "your hand is: #{hand}\n"
    unless cards_on_table.first_turn?
      puts "on the table are these cards: #{cards_on_table}\n"
    end
    string = gets "\n"
    system ("cls")
    card = Card.by_string string
    if not hand.permitted? card, suit
      puts "not permitted card\n"
      input_card suit, cards_on_table
    else
      hand.take_card card
      CardOnTable.new card.suit, card.value, self
    end
  end
end

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

class Game
  def self.introduction
    puts "Number of players:"
    number_of_players = gets("\n").to_i
    players = 1.upto(number_of_players).map do |number_player|
      puts "player no.#{number_player} is"
      name = gets "\n"
      PersonPlayer.new name
    end
    1.upto(4 - number_of_players).each do |number_bot|
      players << BotPlayer.new("bot no.#{number_bot}")
    end
    Game.new players
  end

  def play
    1.upto(16).each do |number|
      current_round = Round.new(number, @players.rotate(number % 4))
      current_round.play
      update_score_table current_round.round_score
    end
  end
end

Game.introduction.play
