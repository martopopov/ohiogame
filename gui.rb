require 'tk'
require 'tkextlib/tile'
require './ohio'
require './bot_player'
require './user_interface/table_hand.rb'
require './user_interface/game_card.rb'
require './user_interface/round.rb'
require './user_interface/player.rb'

$root = TkRoot.new { title "ohio" }

TkGrid.columnconfigure $root, 0, :weight => 1
TkGrid.rowconfigure $root, 0, :weight => 1

players = [PersonPlayer.new('A'), PersonPlayer.new('B'), PersonPlayer.new('C'), PersonPlayer.new('D')]

ohio = (Game.new players).play

Tk.mainloop