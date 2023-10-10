# frozen_string_literal: true

# lib/king.rb

require_relative 'pieces'
require_relative 'chessboard'
# King
class King < Piece
  # Returns valid moves for the king
  def valid_king_moves(spot, board)
    moves = []

    directions = [
      [-1, -1], # up-left
      [-1, 1], # up-right
      [1, -1], # down-left
      [1, 1], # down-right
      [-1, 0], # left
      [1, 0], # right
      [0, -1], # down
      [0, 1] # up
    ]

    # Check all directions for valid moves
    directions.each do |direction|
      row = spot.row + direction[0]
      column = spot.column + direction[1]
      # push moves while checking conditions
      next unless valid_spot?(row, column) && valid_king_move?(self, board, row, column)

      # Create a temporary board to check if the move puts the king in check
      temp_board = board.dup
      temp_board[spot.row][spot.column].piece = nil
      temp_board[row][column].piece = self

      # Check if the move puts the king in check
      moves << [row, column] unless in_check?(self, temp_board, row, column)
    end
    moves
  end

  # checks if the move is valid for king
  def valid_king_move?(king, board, row, column)
    if (board[row][column].empty? || enemy_piece?(king,
                                                  board[row][column].piece)) && !in_check?(king, board, row, column)
      true
    else
      false
    end
  end

  # checks if the king will be in check after move
  def in_check?(king, board, row, column)
    # find all other player's pieces on the board
    enemy_pieces = []
    board.each do |board_row|
      board_row.each do |spot|
        enemy_pieces << spot if !spot.piece.nil? && enemy_piece?(king, spot.piece)
      end
    end
    # now check if the enemy pieces can move to the spot where you just placed the king to
    enemy_pieces.any? do |spot|
      enemy = spot.piece
      moves = enemy.valid_moves(board)
      return true if moves.include?([row, column])
    end
    false
  end
end
