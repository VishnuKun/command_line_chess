# frozen_string_literal: true

# lib/player.rb

# Player
class Player
  attr_accessor :name, :controls_pieces

  def initialize(color)
    @name = nil
    @controls_pieces = color
  end
end
