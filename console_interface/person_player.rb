class PersonPlayer < Player
   def guess_hands(round)
    system ("cls")
    puts "the trump is #{round.trump}\n"
    puts "#{name}, guess how many hands will you make\n"
    puts "your hand is #{hand}"
    prediction = gets("\n")
    prediction.to_i
  end

  def play_card(suit = :first_turn, cards_on_table)
    system ("cls")
    puts "the trump is #{cards_on_table.trump}"
    puts "#{name}, it's your turn\n"
    puts "your hand is: #{hand}\n"

    unless cards_on_table.first_turn?
      puts "on the table are these cards: #{cards_on_table}\n"
    end

    string = gets "\n"
    card = Card.by_string string

    if not hand.permitted? card, suit
      puts "not permitted card\n"
      play_card suit, cards_on_table
    else
      hand.take_card card
      CardOnTable.new card.suit, card.value, self
    end
  end
end