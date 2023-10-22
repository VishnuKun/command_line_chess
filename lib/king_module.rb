# frozen_string_literal: true

# lib/king_module.rb
# contains methods for the King class
module KingModule
  # Returns valid moves for the king
  def valid_king_moves(spot, board)
    moves = []

    directions = [
      [-1, -1], 
      [-1, 1], 
      [1, -1], 
      [1, 1], 
      [-1, 0], 
      [1, 0], 
      [0, -1], 
      [0, 1] 
    ]

    # Check all directions for valid moves
    directions.each do |direction|
      row = spot.row + direction[0]
      column = spot.column + direction[1]
      next unless valid_spot?(row, column) && valid_king_move?(self, board, row, column)

      # Create a deep copy of the board to check if the move puts the king in check
      temp_board = Marshal.load(Marshal.dump(board))
      temp_board[spot.row][spot.column].piece = nil
      temp_board[row][column].piece = self

      moves << [row, column] unless in_check?(self, temp_board, row, column)
    end

    moves << [spot.row, spot.column - 2] if can_castle_to_left?(spot, board) 
    moves << [spot.row, spot.column + 2] if can_castle_to_right?(spot, board) 

    moves
  end

  # helper method to prevent recursion
  def enemy_king_moves(spot, _board)
    moves = []
    directions = [
      [-1, -1], 
      [-1, 1], 
      [1, -1], 
      [1, 1], 
      [-1, 0], 
      [1, 0], 
      [0, -1], 
      [0, 1] 
    ]
    # Check all directions for valid moves
    directions.each do |direction|
      row = spot.row + direction[0]
      column = spot.column + direction[1]
      moves << [row, column]
    end
    moves
  end

  # checks if the move is valid for king
  def valid_king_move?(king, board, row, column)
    if board[row][column].empty? || enemy_piece?(king, board[row][column].piece)
      true
    else
      false
    end
  end

  # Checks if the king will be in check if it moved to given coordinates
  def in_check?(king, board, row, column)
    enemy_pieces = find_enemy_pieces(king, board)

    enemy_pieces.any? do |spot|
      enemy = spot.piece
      can_attack?(spot, enemy, board, row, column)
    end
  end

  # Get enemy pieces on the board
  def find_enemy_pieces(king, board)
    board.flatten.select do |spot|
      !spot.piece.nil? && enemy_piece?(king, spot.piece)
    end
  end

  # check if the piece can attack the piece at the given position
  def can_attack?(spot, enemy, _board, row, column)
    return true if enemy.is_a?(King) && enemy_king_moves(spot, _board).include?([row, column])

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
    return false if moved
    return false if in_check?(self, board, king_spot.row, king_spot.column)

    true
  end

  # performs castling to the left
  def castle_left(board)
    king = self
    king_spot = find_spot(king, board)
    return unless can_castle?(king_spot, board)
    return unless can_castle_to_left?(king_spot, board)

    rook_spot = board[king_spot.row][0]
    rook = rook_spot.piece
    king_spot.piece = nil
    board[king_spot.row][2].piece = king
    rook_spot.piece = nil
    board[king_spot.row][3].piece = rook
    king.moved = true
    rook.moved = true
  end

  # performs castling to the right
  def castle_right(board)
    king = self
    king_spot = find_spot(king, board)
    return unless can_castle?(king_spot, board)

    puts can_castle_to_right?(king_spot, board)
    return unless can_castle_to_right?(king_spot, board)

    rook_spot = board[king_spot.row][7]
    rook = rook_spot.piece
    king_spot.piece = nil
    board[king_spot.row][6].piece = king
    rook_spot.piece = nil
    board[king_spot.row][5].piece = rook
    king.moved = true
    rook.moved = true
  end

  # Checks if the king can castle to the left
  def can_castle_to_left?(king_spot, board)
    return false unless can_castle?(king_spot, board)

    left_rook = board[king_spot.row][0].piece
    return false unless left_rook && !left_rook.moved
    return false unless left_rook.is_a?(Rook)

    return false if board[king_spot.row][1].piece || board[king_spot.row][2].piece || board[king_spot.row][3].piece

    return false if in_check?(self, board, king_spot.row, king_spot.column - 2)

    true
  end

  # Checks if the king can castle to the right
  def can_castle_to_right?(king_spot, board)
    return false unless can_castle?(king_spot, board)

    right_rook = board[king_spot.row][7].piece
    return false unless right_rook && !right_rook.moved
    return false unless right_rook.is_a?(Rook)

    return false if board[king_spot.row][5].piece || board[king_spot.row][6].piece

    return false if in_check?(self, board, king_spot.row, king_spot.column + 2)

    true
  end
end
