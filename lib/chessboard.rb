# frozen_string_literal: true

# lib/chessboard.rb

require_relative 'spot'
# Chessboard
class Chessboard
  attr_accessor :board_array

  def initialize
    @board_array = Array.new(8) { Array.new(8) { Spot.new } }
    add_squares(@board_array)
    @board_array.each_with_index do |row, row_index|
      row.each_with_index do |spot, column_index|
        spot.row = row_index
        spot.column = column_index
      end
    end
  end

  # moves the given piece to the given position on the board
  def move_piece(piece, x, y)
    spot = find_spot(piece)
    spot.piece = nil
    target_spot = @board_array[x][y]
    target_spot.piece = piece
  end

  # removes the piece from the board array at the given position
  def remove_piece(x, y)
    @board_array[x][y].piece = nil
  end

  # adds a piece to the desired position on the board
  def add_piece(piece, x, y)
    @board_array[x][y].piece = piece
  end

  # returns the piece at the given position
  def piece_at(x, y)
    @board_array[x][y].piece
  end

  # add Spot instances to the board array
  def add_squares(board_array)
    board_array.each_with_index do |row, row_index|
      row.each_with_index do |spot, column_index|
        color = (row_index + column_index).even? ? '░░' : '██'
        spot.type = color
      end
    end
  end
end
