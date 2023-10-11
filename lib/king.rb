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

  # performs castling to the left
  def castle_left(board)
    king = self
    king_spot = find_spot(king, board)
    # check if the king can castle
    return unless can_castle?(king_spot, board)
    # check for left rook
    return unless can_castle_to_left?(king_spot, board)

    # move the king and the rook accordingly
    # get rook's spot
    rook_spot = board[king_spot.row][0]
    rook = rook_spot.piece
    # move king to column - 2
    king.move_to(king_spot.row, king_spot.column - 2, board)
    # move rook to column + 3
    rook.move_to(king_spot.row, king_spot.column - 1, board)
  end

  # performs castling to the right
  def castle_right(board)
    king = self
    king_spot = find_spot(king, board)
    # check if the king can castle
    return unless can_castle?(king_spot, board)

    # check for left rook
    puts can_castle_to_right?(king_spot, board)
    return unless can_castle_to_right?(king_spot, board)

    # move the king and the rook accordingly
    # get rook's spot
    rook_spot = board[king_spot.row][7]
    rook = rook_spot.piece
    # move king to column - 2
    king.move_to(king_spot.row, king_spot.column + 2, board)
    # move rook to column + 3
    rook.move_to(king_spot.row, king_spot.column + 1, board)
  end

  # Checks if the king can castle or not
  def can_castle?(king_spot, board)
    # ! King mustn't have moved
    return false if king_spot.piece.moved
    # ! King must not be in check
    return false if in_check?(self, board, king_spot.row, king_spot.column)

    true
  end

  # Checks if the king can castle to the left
  def can_castle_to_left?(king_spot, board)
    # ! left Rook must exist and not be moved
    return false unless board[king_spot.row][0].piece.is_a?(Rook) && !board[king_spot.row][0].piece.moved
    # ! Path between Rook and King should be clear
    return false if board[king_spot.row][1].piece || board[king_spot.row][2].piece || board[king_spot.row][3].piece
    # ! King should not be in check after castling
    return false if in_check?(self, board, king_spot.row, king_spot.column - 2)

    # else return true
    true
  end

  # Checks if the king can castle to the right
  def can_castle_to_right?(king_spot, board)
    # ! right Rook must exist and not be moved
    return false unless board[king_spot.row][7].piece.is_a?(Rook) && !board[king_spot.row][].piece.moved
    # ! Path between Rook and King should be clear
    return false if board[king_spot.row][5].piece || board[king_spot.row][6].piece
    # ! King should not be in check after castling
    return false if in_check?(self, board, king_spot.row, king_spot.column + 2)

    # else return true
    true
  end
end
