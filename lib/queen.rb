# frozen_string_literal: true

# lib/queen.rb

require_relative 'pieces'
require_relative 'chessboard'
# Queen
class Queen < Piece
  # generates valid moves for the queen
  def valid_queen_moves(spot, board)
    moves = []
    diagonal_directions = [
      [-1, -1], # up-left
      [-1, 1], # up-right
      [1, -1], # down-left
      [1, 1] # down-right
    ]
    horizontal_directions = [
      [-1, 0], # left
      [1, 0] # right
    ]
    vertical_directions = [
      [0, -1], # down
      [0, 1] # up
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
    horizontal_directions.each do |direction|
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

    vertical_directions.each do |direction|
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
