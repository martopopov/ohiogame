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