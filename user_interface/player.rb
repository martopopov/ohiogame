class PersonPlayer < Player
  def guess_hands(round, number)
    myself = self
    guess_window = TkToplevel.new { title "baba" }

    hand.each do |card|
      card_image = TkPhotoImage.new(:file => card.get_image_name)
      Tk::Tile::Button.new(guess_window) { image card_image }.grid
    end

    label = Tk::Tile::Button.new(guess_window) { text "#{myself.name}, guess how many hands will you make" }.grid
    test = TkVariable.new
    guess_entry = Tk::Tile::Entry.new(guess_window) { textvariable test }.grid
    done = Tk::Tile::Button.new(guess_window) do
      text "done"

      command do
        round.hand_predictions[self] = guess_entry.get.to_i
        guess_window.destroy
        round.players[number + 1].guess_hands round, number + 1 if number < 3
      end
    end.grid
  end

  def show_other_players_card(count_cards, frame)
    back_image = TkPhotoImage.new(:file => 'cards/back.gif')
    1.upto(count_cards).each do |n|
      Tk::Tile::Button.new(frame) { image back_image }.
      grid(:column => 0, :row => n + 2, :sticky => 'w')

      Tk::Tile::Button.new(frame) { image back_image }.
      grid(:column => n + 4, :row => 0, :sticky => 'n')

      Tk::Tile::Button.new(frame) { image back_image }.
      grid(:column => 20, :row => n + 2, :sticky => 'e')
    end
  end

  def play_card(current_table_hand, current_round)
    frame = Tk::Tile::Frame.new($root).grid
    myself = self
    hand.each_with_index do |card, index|
      card_image = TkPhotoImage.new(:file => card.get_image_name)

      card_button = Tk::Tile::Button.new(frame) do

        image card_image

        command do
          frame.grid_forget

          if current_table_hand.count_cards > 0
            current_table_hand.delete_labels
          end

          myself.hand.take_card card

          if current_table_hand.count_cards == 3
            current_round.play_hand current_table_hand, myself.hand.count
            frame.grid_forget
          else
            current_table_hand.new_card_hand(CardOnTable.new card.suit, card.value, myself).play(current_round, frame)
          end
        end

      end.grid(:column => index, :row => 20, :sticky => 'sew')

      show_other_players_card(myself.hand.count, frame)

      card_button.state('disabled') unless hand.permitted? card, current_table_hand.suit
    end
  end
end