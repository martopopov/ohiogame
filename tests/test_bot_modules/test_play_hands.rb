class TestPlayHands < MiniTest::Unit::TestCase

  def sample
    BotHand.new [Card.new('Club','Q'), Card.new('Club', '7'), Card.new('Spade', '7'),
      Card.new('Spade', '10'), Card.new('Spade', 'A'), Card.new('Heart','5')]
  end

  def sample_taken_cards
    [Card.new('Club', 'J'), Card.new('Club','A'), Card.new('Diamond','K'),
     Card.new('Spade','2'), Card.new('Diamond', 'A')]
  end

  def test_taken_cards
    players = [Player.new('A'), Player.new('B'), Player.new('C'), Player.new('D')]
    players[0].hand = Hand.new [Card.new('Diamond', 'A')]
    players[1].hand = Hand.new [Card.new('Diamond', 'Q')]
    players[2].hand = Hand.new [Card.new('Diamond', '2')]
    players[3].hand = Hand.new [Card.new('Diamond', '6')]
    players[0].hand.take_card Card.new('Diamond', 'A')
    players[1].hand.take_card Card.new('Diamond','Q')
    assert_equal sample.taken_cards(players), [Card.new('Diamond', 'A'), Card.new('Diamond', 'Q')]
  end

  def test_available_card
    assert_equal sample.available_cards(sample_taken_cards).count, 47
  end

  def test_leading_card_of_suit
    assert_equal sample.leading_card_of_suit(sample_taken_cards, 'Club'), Card.new('Club', 'K')
    assert_equal sample.leading_card_of_suit(sample_taken_cards, 'Diamond'), Card.new('Diamond', 'Q')
  end

  def test_leading
    card = Card.new('Club', 'K')
    card_2 = Card.new('Spade','2')
    card_3 = Card.new('Spade','K')
    assert sample.leading? card, 'Club', sample_taken_cards, 'Diamond'
    assert sample.leading? card_2, 'Spade', sample_taken_cards, 'Spade'
    refute sample.leading? card_3, 'Diamond', sample_taken_cards, 'Diamond'
  end

  def test_all_leading_cards
    leading_cards = sample.all_leading_cards(sample_taken_cards, :first_turn, 'Heart')
    assert_equal leading_cards, [Card.new('Spade','A'), Card.new('Heart','5')]
  end

  def test_permitted_cards
  #assert_equal sample.permitted_cards('Diamond'), sample
  #assert_equal sample.permitted_cards, sample
  assert_equal sample.permitted_cards('Club'), [Card.new('Club','Q'), Card.new('Club','7')]
  end

  def test_play
    assert_equal sample.play(sample_taken_cards, 'Club', 'Diamond'), Card.new('Club','7')
    assert_equal sample.play(sample_taken_cards, 'Diamond', 'Heart'), Card.new('Heart','5')
    assert_equal sample.play(sample_taken_cards, 'Heart', 'Diamond'), Card.new('Heart','5')
  end
end