class Game
  attr_accessor :score_table

  def initialize(players)
    @players = players
    @score_table = Hash[players.zip([0, 0, 0, 0])]
  end

  def update_score_table(round_score_table)
    score_table.update(round_score_table) { |player, old_score, round_score| old_score + round_score }
  end
end