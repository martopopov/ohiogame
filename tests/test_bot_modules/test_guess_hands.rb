class TestGuessHands < MiniTest::Unit::TestCase
  def test_low_round
    low_round_hand = BotHand.new [Card.new('Club','Q'), Card.new('Club', '7'), Card.new('Spade', '7')]
    assert_equal low_round_hand.low_round_guess_hands('Club'), 2
    assert_equal low_round_hand.low_round_guess_hands('Diamond'), 0
  end

  def test_medium_round
    medium_round_hand = BotHand.new [Card.new('Club', 'J'), Card.new('Club','A'),
      Card.new('Diamond','K'), Card.new('Spade','2'), Card.new('Diamond', 'A')]
    assert_equal medium_round_hand.medium_round_guess_hands('Club'), 3
    assert_equal medium_round_hand.medium_round_guess_hands('Heart'), 2
  end

  def test_high_round
    high_round_hand = BotHand.new [Card.new('Club', 'J'), Card.new('Club','A'), Card.new('Diamond','K'),
      Card.new('Spade','2'), Card.new('Diamond', 'A'), Card.new('Spade', '3'), Card.new('Heart', 'K')]
    assert_equal high_round_hand.high_round_guess_hands('Club'), 5
    assert_equal high_round_hand.high_round_guess_hands('Heart'), 4
  end

  def test_no_trump
    high_round_hand = BotHand.new ([11, 12, 24, 25, 37, 38, 50, 51, 1, 2, 3, 4, 5].map { |id| Card.by_id(id) })
    assert_equal high_round_hand.no_trump_guess_hands, 8
  end
end