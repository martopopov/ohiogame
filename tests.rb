require 'minitest/unit'
require './bot_player'
require './tests/test_deck'
require './tests/test_bot'
require './tests/test_card'
require './tests/test_game'
require './tests/test_hand'
require './tests/test_round'
require './tests/test_table_hand'
require './tests/test_bot_modules/test_guess_hands'
require './tests/test_bot_modules/test_play_hands'

# class TestDeck < MiniTest::Unit::TestCase
#   def test_deal
#     a_deck = Deck.new
#     a_deck.deal(4).each { |hand| assert_equal 4, hand.count }
#   end

#   def test_trump
#     a_deck  = Deck.new
#     assert_equal a_deck.trump(13), :no_trump
#     assert_includes %w(Spade Heart Club Diamond), a_deck.trump(10)
#   end
# end

# class TestCard < MiniTest::Unit::TestCase
#    def test_by_id
#      assert_equal Card.by_id(50).suit, 'Diamond'
#      assert_equal Card.by_id(50).value, 'K'
#    end

#   def test_comparison_of_values
#     a_card = Card.new 'Spade', 'A'
#     b_card = Card.new 'Diamond', 'Q'
#     c_card = Card.new 'Spade','A'
#     d_card = Card.new 'Diamond', 'A'
#     assert a_card >= b_card
#     assert a_card == c_card
#     refute a_card == d_card
#   end

#   def test_by_string
#     a_card = Card.by_string 'A Spade'
#     b_card = Card.by_string '10 Diamond'
#     assert_equal a_card.suit, 'Spade'
#     assert_equal b_card.value, '10'
#   end

#   def test_comparison_when_trump_matters
#     a_card = Card.new 'Spade', 'A'
#     b_card = Card.new 'Diamond', 'Q'
#     c_card = Card.new 'Diamond', '10'
#     d_card = Card.new 'Clubs', '7'
#     assert a_card.greater? b_card, 'Spade'
#     assert c_card.greater? a_card, 'Diamond'
#     refute (a_card.greater? c_card, 'Diamond')
#     assert b_card.greater? c_card, 'Diamond'
#     assert b_card.greater? c_card, 'Clubs'
#   end

#   def test_all_cards_of_suit
#     a_card = Card.new 'Spade', 'A'
#     assert_equal a_card.all_cards_of_suit, 0.upto(12).map { |id| Card.by_id(id) }
#   end

#   def test_to_s
#     a_card = Card.new 'Spade', 'A'
#     assert_equal a_card.to_s, 'A Spade'
#   end

#   def test_greater_cards_same_suit
#     a_card = Card.new 'Spade', 'J'
#     assert_equal a_card.greater_cards_same_suit, [Card.new('Spade', 'Q'), Card.new('Spade', 'K'), Card.new('Spade', 'A')]
#   end
# end

# class TestHand < MiniTest::Unit::TestCase
#   def example
#     Hand.new ([5, 30, 23, 49, 1, 9, 22, 41, 35, 14].map { |id| Card.by_id(id) })
#   end

#   def test_init
#     assert_equal  10, example.count
#   end

#   def test_take_card
#     hand = Hand.new ([5, 30, 23, 49, 1, 9, 22, 41, 35, 14].map { |id| Card.by_id(id) })
#     hand.take_card(Card.by_id 22)
#     assert_equal hand.count, 9
#     hand.take_card(Card.by_id 41)
#     assert_equal hand.count, 8
#     hand.take_card(Card.by_id 42)
#     assert_equal hand.count, 8
#     assert_equal [Card.by_id(22), Card.by_id(41)], hand.played_cards
#   end

#   def test_to_s
#     hand = Hand.new [Card.new('Spade', '7'), Card.new('Diamond', 'Q'), Card.new('Club','5')]
#     assert_equal hand.to_s, '7 Spade, Q Diamond, 5 Club'
#   end

#   def test_has_suit
#     a_hand = Hand.new(1.upto(13).to_a.map { |id| Card.by_id(id) })
#     assert a_hand.has_suit? 'Spade'
#     assert_equal (a_hand.has_suit? 'Diamond'), false
#   end

#   def test_has_card
#     assert example.has_card? Card.by_id(30)
#     assert_equal (example.has_card? Card.by_id(31)), false
#   end

#   def test_permitted
#     a_hand = Hand.new ([5, 30, 23, 19, 1, 9, 22, 31, 35, 14].map { |id| Card.by_id(id) })
#     refute (a_hand.permitted? (Card.new 'Spade', '7'), 'Heart')
#     refute (a_hand.permitted? (Card.new 'Spade', '6'), 'Spade')
#     assert (a_hand.permitted? (Card.new 'Spade', '7'), 'Spade')
#     assert (a_hand.permitted? (Card.new 'Spade', '7'), 'Diamond')
#   end
# end

# class TestTableHand < MiniTest::Unit::TestCase
#   def test_new_card_hand
#     players = [Player.new('A'), Player.new('B'), Player.new('C'), Player.new('D')]
#     trump = 'Club'
#     hand = TableHand.new players, trump
#     new_hand = hand.new_card_hand CardOnTable.new('Spade', '7', Player.new('A'))
#     assert_equal new_hand.players[0], Player.new('B')
#     assert new_hand.cards.member? Card.new('Spade', '7')
#     assert_equal new_hand.count_cards, 1

#     new_hand = new_hand.new_card_hand CardOnTable.new('Club', 'Q', Player.new('B'))
#     assert_equal new_hand.players[0], Player.new('C')
#     assert new_hand.cards.member? Card.new('Club','Q')
#     assert_equal new_hand.winner, Player.new('B')

#     new_hand = new_hand.new_card_hand CardOnTable.new('Diamond','A', Player.new('C'))
#     assert_equal new_hand.players[0], Player.new('D')
#     assert_equal new_hand.winner, Player.new('B')
#     assert_equal new_hand.count_cards, 3
#     assert_equal new_hand.to_s, '7 Spade, Q Club, A Diamond'
#   end
# end

# class TestRound < MiniTest::Unit::TestCase
#   def test_new_order
#     players = [Player.new('A'), Player.new('B'), Player.new('C'), Player.new('D')]
#     round = Round.new(3, players)
#     new_order_players = round.new_order players, Player.new('C')
#     assert_equal new_order_players, players.rotate(2)
#   end

#   def test_deal
#     players = [Player.new('A'), Player.new('B'), Player.new('C'), Player.new('D')]
#     round = Round.new(3, players)
#     round.deal
#     assert_equal players[0].hand.count, 3
#     assert_includes ['Spade', 'Diamond', 'Club', 'Heart'], round.trump
#   end
# end

# class TestBotHand < MiniTest::Unit::TestCase
#   HAND = BotHand.new [Card.new('Club','Q'), Card.new('Club', '7'),
#    Card.new('Spade', '7'), Card.new('Spade', '10'), Card.new('Spade', 'A')]

#   def test_cards_of_suit
#     assert_equal HAND.cards_of_suit('Club'), [Card.new('Club','Q'), Card.new('Club', '7')]
#   end

#   def test_best_and_worst_card
#     assert_equal HAND.best_card_of_suit('Spade'), Card.new('Spade', 'A')
#     assert_equal HAND.worst_card_of_suit('Spade'), Card.new('Spade', '7')
#     #assert_equal HAND.worst_permitted_card('Club'), Card.new('Club', 7)
#   end
# end

# class TestGuessHands < MiniTest::Unit::TestCase
#   def test_low_round
#     low_round_hand = BotHand.new [Card.new('Club','Q'), Card.new('Club', '7'), Card.new('Spade', '7')]
#     assert_equal low_round_hand.low_round_guess_hands('Club'), 2
#     assert_equal low_round_hand.low_round_guess_hands('Diamond'), 0
#   end

#   def test_medium_round
#     medium_round_hand = BotHand.new [Card.new('Club', 'J'), Card.new('Club','A'),
#       Card.new('Diamond','K'), Card.new('Spade','2'), Card.new('Diamond', 'A')]
#     assert_equal medium_round_hand.medium_round_guess_hands('Club'), 3
#     assert_equal medium_round_hand.medium_round_guess_hands('Heart'), 2
#   end

#   def test_high_round
#     high_round_hand = BotHand.new [Card.new('Club', 'J'), Card.new('Club','A'), Card.new('Diamond','K'),
#       Card.new('Spade','2'), Card.new('Diamond', 'A'), Card.new('Spade', '3'), Card.new('Heart', 'K')]
#     assert_equal high_round_hand.high_round_guess_hands('Club'), 5
#     assert_equal high_round_hand.high_round_guess_hands('Heart'), 4
#   end

#   def test_no_trump
#     high_round_hand = BotHand.new ([11, 12, 24, 25, 37, 38, 50, 51, 1, 2, 3, 4, 5].map { |id| Card.by_id(id) })
#     assert_equal high_round_hand.no_trump_guess_hands, 8
#   end
# end

# class TestPlayHands < MiniTest::Unit::TestCase

#   def sample
#     BotHand.new [Card.new('Club','Q'), Card.new('Club', '7'), Card.new('Spade', '7'),
#       Card.new('Spade', '10'), Card.new('Spade', 'A'), Card.new('Heart','5')]
#   end

#   def sample_taken_cards
#     [Card.new('Club', 'J'), Card.new('Club','A'), Card.new('Diamond','K'),
#      Card.new('Spade','2'), Card.new('Diamond', 'A')]
#   end

#   def test_taken_cards
#     players = [Player.new('A'), Player.new('B'), Player.new('C'), Player.new('D')]
#     players[0].hand = Hand.new [Card.new('Diamond', 'A')]
#     players[1].hand = Hand.new [Card.new('Diamond', 'Q')]
#     players[2].hand = Hand.new [Card.new('Diamond', '2')]
#     players[3].hand = Hand.new [Card.new('Diamond', '6')]
#     players[0].hand.take_card Card.new('Diamond', 'A')
#     players[1].hand.take_card Card.new('Diamond','Q')
#     assert_equal sample.taken_cards(players), [Card.new('Diamond', 'A'), Card.new('Diamond', 'Q')]
#   end

#   def test_available_card
#     assert_equal sample.available_cards(sample_taken_cards).count, 47
#   end

#   def test_leading_card_of_suit
#     assert_equal sample.leading_card_of_suit(sample_taken_cards, 'Club'), Card.new('Club', 'K')
#     assert_equal sample.leading_card_of_suit(sample_taken_cards, 'Diamond'), Card.new('Diamond', 'Q')
#   end

#   def test_leading
#     card = Card.new('Club', 'K')
#     card_2 = Card.new('Spade','2')
#     card_3 = Card.new('Spade','K')
#     assert sample.leading? card, 'Club', sample_taken_cards, 'Diamond'
#     assert sample.leading? card_2, 'Spade', sample_taken_cards, 'Spade'
#     refute sample.leading? card_3, 'Diamond', sample_taken_cards, 'Diamond'
#   end

#   def test_all_leading_cards
#     leading_cards = sample.all_leading_cards(sample_taken_cards, :first_turn, 'Heart')
#     assert_equal leading_cards, [Card.new('Spade','A'), Card.new('Heart','5')]
#   end

#   def test_permitted_cards
#   #assert_equal sample.permitted_cards('Diamond'), sample
#   #assert_equal sample.permitted_cards, sample
#   assert_equal sample.permitted_cards('Club'), [Card.new('Club','Q'), Card.new('Club','7')]
#   end

#   def test_play
#     assert_equal sample.play(sample_taken_cards, 'Club', 'Diamond'), Card.new('Club','7')
#     assert_equal sample.play(sample_taken_cards, 'Diamond', 'Heart'), Card.new('Heart','5')
#     assert_equal sample.play(sample_taken_cards, 'Heart', 'Diamond'), Card.new('Heart','5')
#   end
# end

# class TestGame < MiniTest::Unit::TestCase
#   def test_init
#     players = [Player.new('A'), Player.new('B'), Player.new('C'), Player.new('D')]
#     game = Game.new players
#     assert_equal game.score_table.keys, players
#     assert_equal game.score_table.values, [0,0,0,0]
#   end

#   def test_score_update
#     players = [Player.new('A'), Player.new('B'), Player.new('C'), Player.new('D')]
#     game = Game.new players
#     game.update_score_table players[0] => 10, players[1] => 19, players[2] => 26, players[3] => 0
#     assert_equal game.score_table[players[2]], 26
#     game.update_score_table players[0] => 11, players[1] => 26, players[2] => 0, players[3] => 16
#     assert_equal game.score_table[players[1]], 45
#     assert_equal game.score_table[players[3]], 16
#   end
# end