class TestBotHand < MiniTest::Unit::TestCase
  HAND = BotHand.new [Card.new('Club','Q'), Card.new('Club', '7'),
   Card.new('Spade', '7'), Card.new('Spade', '10'), Card.new('Spade', 'A')]

  def test_cards_of_suit
    assert_equal HAND.cards_of_suit('Club'), [Card.new('Club','Q'), Card.new('Club', '7')]
  end

  def test_best_and_worst_card
    assert_equal HAND.best_card_of_suit('Spade'), Card.new('Spade', 'A')
    assert_equal HAND.worst_card_of_suit('Spade'), Card.new('Spade', '7')
    #assert_equal HAND.worst_permitted_card('Club'), Card.new('Club', 7)
  end
end