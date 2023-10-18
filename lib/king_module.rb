# frozen_string_literal: true

# lib/king_module.rb
# contains methods for the King class
module KingModule
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

    # insert castling moves if possible
    moves << [spot.row, spot.column - 2] if can_castle_to_left?(spot, board) # left castling move
    moves << [spot.row, spot.column + 2] if can_castle_to_right?(spot, board) # left castling move

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
    # check if the spot is empty or it contains enemy piece
    if board[row][column].empty? || enemy_piece?(king, board[row][column].piece)
      true
    else
      false
    end
  end

  # Checks if the king is in check
  def in_check?(king, board, row, column)
    # Iterate through all the enemy pieces on the board
    enemy_pieces = find_enemy_pieces(king, board)

    enemy_pieces.any? do |spot|
      enemy = spot.piece
      # Check if the enemy piece can attack the king's current position
      can_attack?(enemy, board, row, column)
    end
  end

  # Get enemy pieces on the board
  def find_enemy_pieces(king, board)
    board.flatten.select do |spot|
      !spot.piece.nil? && enemy_piece?(king, spot.piece)
    end
  end

  # check if the piece can attack the piece at the given position
  def can_attack?(enemy, _board, row, column)
    case enemy
    when Pawn
      return true if enemy.valid_moves(_board).include?([row, column])
    when Knight
      return true if enemy.valid_moves(_board).include?([row, column])
    when Bishop
      return true if enemy.valid_moves(_board).include?([row, column])
    when Rook
      return true if enemy.valid_moves(_board).include?([row, column])
    when Queen
      return true if enemy.valid_moves(_board).include?([row, column])
    else
      false
    end
  end

  # Checks if the king can castle or not
  def can_castle?(king_spot, board)
    # ! King mustn't have moved
    return false if moved
    # ! King must not be in check
    return false if in_check?(self, board, king_spot.row, king_spot.column)

    true
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

  # Checks if the king can castle to the left
  def can_castle_to_left?(king_spot, board)
    # Check king first
    return false unless can_castle?(king_spot, board)

    left_rook = board[king_spot.row][0].piece
    # ! left Rook must exist and not be moved
    # check if left rook exists and it has not moved
    return false unless left_rook && !left_rook.moved
    return false unless left_rook.is_a?(Rook)

    # ! Path between Rook and King should be clear
    return false if board[king_spot.row][1].piece || board[king_spot.row][2].piece || board[king_spot.row][3].piece

    # ! King should not be in check after castling
    return false if in_check?(self, board, king_spot.row, king_spot.column - 2)

    # else return true
    true
  end

  # Checks if the king can castle to the right
  def can_castle_to_right?(king_spot, board)
    # Check king first
    return false unless can_castle?(king_spot, board)

    right_rook = board[king_spot.row][7].piece
    # ! right Rook must exist and not be moved
    # check if right rook exists and it has not moved
    return false unless right_rook && !right_rook.moved
    return false unless right_rook.is_a?(Rook)

    # ! Path between Rook and King should be clear
    return false if board[king_spot.row][5].piece || board[king_spot.row][6].piece

    # ! King should not be in check after castling
    return false if in_check?(self, board, king_spot.row, king_spot.column + 2)

    # else return true
    true
  end
end
