class TestGame < MiniTest::Unit::TestCase
  def test_init
    players = [Player.new('A'), Player.new('B'), Player.new('C'), Player.new('D')]
    game = Game.new players
    assert_equal game.score_table.keys, players
    assert_equal game.score_table.values, [0,0,0,0]
  end

  def test_score_update
    players = [Player.new('A'), Player.new('B'), Player.new('C'), Player.new('D')]
    game = Game.new players
    game.update_score_table players[0] => 10, players[1] => 19, players[2] => 26, players[3] => 0
    assert_equal game.score_table[players[2]], 26
    game.update_score_table players[0] => 11, players[1] => 26, players[2] => 0, players[3] => 16
    assert_equal game.score_table[players[1]], 45
    assert_equal game.score_table[players[3]], 16
  end
end