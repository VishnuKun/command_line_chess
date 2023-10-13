# lib/main.rb
require_relative 'game'
require_relative 'pieces'

game = Game.new
game.current_player = game.player1
p game.check_mate?


