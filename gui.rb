require 'tk'
require 'tkextlib/tile'
require './ohio'
require './bot_player'

$root = TkRoot.new { title "ohio" }
$content = Tk::Tile::Frame.new($root) { padding "3 3 12 12" }.grid(:sticky => 'nsew')

TkGrid.columnconfigure $root, 0, :weight => 1; TkGrid.rowconfigure $root, 0, :weight => 1

class PersonPlayer < Player
  def guess_hands(round, number)
    myself = self
    guess_window = TkToplevel.new { title "baba" }
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

class  Game
  def play
    (Round.new 1, @players).visualize_deal
  end
end

class Card
  def get_image_name
    "cards/#{value}#{suit}.gif"
  end
end

class Round
  attr_accessor :hand_predictions

  def visualize_deal
    @hand_predictions = {}
    deal
    players[0].guess_hands self, number
    current_table_hand = TableHand.new(players, @trump)
    play_hand current_table_hand, number
  end


  def play_hand(table_hand, number)
    if number != 0

      if table_hand.count_cards == 3
        master_player = table_hand.winner
        @hand_counts[master_player] += 1
        master_player.play_card TableHand.new(new_order(@players, master_player), @trump), self

      else
        players[0].play_card table_hand, self
      end

    else
      (Round.new @number + 1, players).visualize_deal if @number < 16
    end
  end

  def round_score
    players.each_with_object({}) do |player, table|
      if @hand_predictions[player] == @hand_counts[player] and @hand_predictions[player] == 0 and number > 12
        table[player] = 50
      elsif @hand_predictions[player] == @hand_counts[player]
        table[player] = 10 + @hand_counts[player] ** 2
      else
        table[player] = 0
      end
    end
  end
end

class TableHand
  attr_accessor :frame

  def fill_frame(frame)
    @frame = frame
    @card_images = cards.map do |card|
      card_image = TkPhotoImage.new(:file => card.get_image_name)
      Tk::Tile::Label.new(@frame) { image card_image }.grid(:column => 1 + cards.index(card), :row => 1)
    end
  end

  def delete_labels
    @card_images.each { |label| label.grid_forget }
  end

  def play(round, frame)
    if @count_cards < 4
      fill_frame @frame
      players[0].play_card self, round
    else
      fill_frame @frame
      delete_labels
    end
  end
end

players = [PersonPlayer.new('A'), PersonPlayer.new('B'), PersonPlayer.new('C'), PersonPlayer.new('D')]

ohio = (Game.new players).play

Tk.mainloop