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