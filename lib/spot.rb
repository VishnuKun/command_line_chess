# frozen_string_literal: true

# lib/spot.rb
# Spot
class Spot
  attr_accessor :row, :column, :piece, :type

  def initialize
    @row = nil
    @column = nil
    @piece = nil
    @type = nil
  end

  # checks whether the spot holds a piece or not
  def empty?
    piece.nil?
  end
end
