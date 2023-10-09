# frozen_string_literal: true

# lib/bishop.rb

require_relative 'pieces'
require_relative 'chessboard'
# Bishop
class Bishop < Piece
  # generates valid moves
  def valid_bishop_moves(spot, board)
    moves = []
    diagonal_directions = [
      [-1, -1], # up-left
      [-1, 1], # up-right
      [1, -1], # down-left
      [1, 1] # down-right
    ]
    diagonal_directions.each do |direction|
      row = spot.row
      column = spot.column
      loop do
        row += direction[0]
        column += direction[1]
        break unless valid_spot?(row, column)

        current_spot = board[row][column]
        unless current_spot.empty?
          if enemy_piece?(self, current_spot.piece)
            moves << [current_spot.row, current_spot.column]
            break
          end
          break unless enemy_piece?(self, current_spot.piece)
        end
        moves << [current_spot.row, current_spot.column]
      end
    end
    moves
  end
end
