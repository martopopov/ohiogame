class TestCard < MiniTest::Unit::TestCase
   def test_by_id
     assert_equal Card.by_id(50).suit, 'Diamond'
     assert_equal Card.by_id(50).value, 'K'
   end

  def test_comparison_of_values
    a_card = Card.new 'Spade', 'A'
    b_card = Card.new 'Diamond', 'Q'
    c_card = Card.new 'Spade','A'
    d_card = Card.new 'Diamond', 'A'
    assert a_card >= b_card
    assert a_card == c_card
    refute a_card == d_card
  end

  def test_by_string
    a_card = Card.by_string 'A Spade'
    b_card = Card.by_string '10 Diamond'
    assert_equal a_card.suit, 'Spade'
    assert_equal b_card.value, '10'
  end

  def test_comparison_when_trump_matters
    a_card = Card.new 'Spade', 'A'
    b_card = Card.new 'Diamond', 'Q'
    c_card = Card.new 'Diamond', '10'
    d_card = Card.new 'Clubs', '7'
    assert a_card.greater? b_card, 'Spade'
    assert c_card.greater? a_card, 'Diamond'
    refute (a_card.greater? c_card, 'Diamond')
    assert b_card.greater? c_card, 'Diamond'
    assert b_card.greater? c_card, 'Clubs'
  end

  def test_all_cards_of_suit
    a_card = Card.new 'Spade', 'A'
    assert_equal a_card.all_cards_of_suit, 0.upto(12).map { |id| Card.by_id(id) }
  end

  def test_to_s
    a_card = Card.new 'Spade', 'A'
    assert_equal a_card.to_s, 'A Spade'
  end

  def test_greater_cards_same_suit
    a_card = Card.new 'Spade', 'J'
    assert_equal a_card.greater_cards_same_suit, [Card.new('Spade', 'Q'), Card.new('Spade', 'K'), Card.new('Spade', 'A')]
  end
end