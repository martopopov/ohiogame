class TestHand < MiniTest::Unit::TestCase
  def example
    Hand.new ([5, 30, 23, 49, 1, 9, 22, 41, 35, 14].map { |id| Card.by_id(id) })
  end

  def test_init
    assert_equal  10, example.count
  end

  def test_take_card
    hand = Hand.new ([5, 30, 23, 49, 1, 9, 22, 41, 35, 14].map { |id| Card.by_id(id) })
    hand.take_card(Card.by_id 22)
    assert_equal hand.count, 9
    hand.take_card(Card.by_id 41)
    assert_equal hand.count, 8
    hand.take_card(Card.by_id 42)
    assert_equal hand.count, 8
    assert_equal [Card.by_id(22), Card.by_id(41)], hand.played_cards
  end

  def test_to_s
    hand = Hand.new [Card.new('Spade', '7'), Card.new('Diamond', 'Q'), Card.new('Club','5')]
    assert_equal hand.to_s, '7 Spade, Q Diamond, 5 Club'
  end

  def test_has_suit
    a_hand = Hand.new(1.upto(13).to_a.map { |id| Card.by_id(id) })
    assert a_hand.has_suit? 'Spade'
    assert_equal (a_hand.has_suit? 'Diamond'), false
  end

  def test_has_card
    assert example.has_card? Card.by_id(30)
    assert_equal (example.has_card? Card.by_id(31)), false
  end

  def test_permitted
    a_hand = Hand.new ([5, 30, 23, 19, 1, 9, 22, 31, 35, 14].map { |id| Card.by_id(id) })
    refute (a_hand.permitted? (Card.new 'Spade', '7'), 'Heart')
    refute (a_hand.permitted? (Card.new 'Spade', '6'), 'Spade')
    assert (a_hand.permitted? (Card.new 'Spade', '7'), 'Spade')
    assert (a_hand.permitted? (Card.new 'Spade', '7'), 'Diamond')
  end
end