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
    puts "The Final Score is:\n"
    score_table.each do |player, score|
      puts "#{player}: #{score}"
    end
  end
end