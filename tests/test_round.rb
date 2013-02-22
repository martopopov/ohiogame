class TestRound < MiniTest::Unit::TestCase
  def test_new_order
    players = [Player.new('A'), Player.new('B'), Player.new('C'), Player.new('D')]
    round = Round.new(3, players)
    new_order_players = round.new_order players, Player.new('C')
    assert_equal new_order_players, players.rotate(2)
  end

  def test_deal
    players = [Player.new('A'), Player.new('B'), Player.new('C'), Player.new('D')]
    round = Round.new(3, players)
    round.deal
    assert_equal players[0].hand.count, 3
    assert_includes ['Spade', 'Diamond', 'Club', 'Heart'], round.trump
  end
end