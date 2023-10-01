# frozen_string_literal: true

# lib/chessboard.rb

require_relative 'spot'

class Chessboard
  attr_accessor :board_array

  def initialize
    @board_array = Array.new(8) { Array.new(8) { Spot.new } }
    add_squares(@board_array)
  end

  def move_piece(piece, x, y); end

  def remove_piece(x, y); end

  def add_squares(board_array)
    board_array.each_with_index do |row, row_index|
      row.each_with_index do |spot, column_index|
        color = (row_index + column_index).even? ? "░░" : "██"
        spot.type = color
      end
    end
  end

  def add_piece(piece, x, y); end

  def piece_at(x, y); end
end
