# frozen_string_literal: true

# lib/knight.rb

require_relative 'pieces'
require_relative 'chessboard'

class Knight < Piece
  def initialize(piece_id)
    super(piece_id)
  end

  def valid_knight_moves(spot, board)
    moves = []
    b = board
    x = spot.row
    y = spot.column
    piece_class = spot.piece.piece_id
    possible_spots = [
      b[x - 2][y - 1], b[x - 2][y + 1],
      b[x - 1][y - 2], b[x - 1][y + 2],
      b[x + 1][y - 2], b[x + 1][y + 2],
      b[x + 2][y - 1], b[x + 2][y + 1]
    ]
    # check if all the possible spots doesn't contain any friendly piece
    possible_spots.each do |move|
      moves << [move.row, move.column] if move && (move.empty? || enemy_piece?(self, move.piece))
    end
    moves
  end
end
