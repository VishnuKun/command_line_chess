# frozen_string_literal: true

# lib/spot.rb

class Spot
  attr_accessor :row, :column, :piece, :type

  def initialize
    @row = nil
    @column = nil
    @piece = nil
    @type = nil
  end

  def emtpy?
    self.piece.nil?
  end
end
