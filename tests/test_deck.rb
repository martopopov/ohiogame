class TestDeck < MiniTest::Unit::TestCase
  def test_deal
    a_deck = Deck.new
    a_deck.deal(4).each { |hand| assert_equal 4, hand.count }
  end

  def test_trump
    a_deck  = Deck.new
    assert_equal a_deck.trump(13), :no_trump
    assert_includes %w(Spade Heart Club Diamond), a_deck.trump(10)
  end
end