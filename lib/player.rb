# frozen_string_literal: true

# lib/player.rb

# Player
class Player
  attr_accessor :name, :controls_pieces

  def initialize(name, color)
    @name = name
    @controls_pieces = color
  end
end
