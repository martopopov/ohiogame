class TestTableHand < MiniTest::Unit::TestCase
  def test_new_card_hand
    players = [Player.new('A'), Player.new('B'), Player.new('C'), Player.new('D')]
    trump = 'Club'
    hand = TableHand.new players, trump
    new_hand = hand.new_card_hand CardOnTable.new('Spade', '7', Player.new('A'))
    assert_equal new_hand.players[0], Player.new('B')
    assert new_hand.cards.member? Card.new('Spade', '7')
    assert_equal new_hand.count_cards, 1

    new_hand = new_hand.new_card_hand CardOnTable.new('Club', 'Q', Player.new('B'))
    assert_equal new_hand.players[0], Player.new('C')
    assert new_hand.cards.member? Card.new('Club','Q')
    assert_equal new_hand.winner, Player.new('B')

    new_hand = new_hand.new_card_hand CardOnTable.new('Diamond','A', Player.new('C'))
    assert_equal new_hand.players[0], Player.new('D')
    assert_equal new_hand.winner, Player.new('B')
    assert_equal new_hand.count_cards, 3
    assert_equal new_hand.to_s, '7 Spade, Q Club, A Diamond'
  end
end