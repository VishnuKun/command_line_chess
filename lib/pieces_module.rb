# frozen_string_literal: true

# lib/pieces_module.rb

# contains general methods for all subclasses of Piece class
module PieceModule
  # sets the symbol to the piece according to the piece id
  def set_symbol(piece_id)
    case piece_id
    when 1
      '♙'
    when -1
      '♟'
    when 2
      '♘'
    when -2
      '♞'
    when 3
      '♗'
    when -3
      '♝'
    when 4
      '♖'
    when -4
      '♜'
    when 5
      '♕'
    when -5
      '♚'
    when 6
      '♔'
    when -6
      '♛'
    end
  end

  # sets the color to the piece according to the piece id
  def set_color(piece_id)
    piece_id.negative? ? 'white' : 'black'
  end

  # returns the position where piece can be placed on board
  def valid_moves(board_array)
    moves = []
    current_spot = find_spot(self, board_array)
    id = piece_id
    case id
    when 1, -1 # Pawn
      moves = valid_pawn_moves(current_spot, board_array)
    when 2, -2 # Knight
      moves = valid_knight_moves(current_spot, board_array)
    when 3, -3 # Bishop
      moves = valid_bishop_moves(current_spot, board_array)
    when 4, -4 # Rook
      moves = valid_rook_moves(current_spot, board_array)
    when 5, -6 # Queen
      moves = valid_queen_moves(current_spot, board_array)
    when 6, -5 # King
      moves = valid_king_moves(current_spot, board_array)
    end
    moves
  end

  # checks if the spot is valid as per board boundaries
  def valid_spot?(x, y)
    board_size = 8
    x >= 0 && x < board_size && y >= 0 && y < board_size
  end

  # checks if the two pieces are enemies or friends
  def enemy_piece?(current_piece, piece_to_check)
    current_piece.color != piece_to_check.color
  end

  # finds the spot in which given piece is inside
  def find_spot(piece, spot_array)
    spot_array.each do |row|
      row.each do |spot|
        return spot if spot.piece == piece
      end
    end
  end

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

  # gives valid spots on board where piece can move to
  def valid_rook_moves(spot, board)
    moves = []
    horizontal_directions = [
      [-1, 0], # left
      [1, 0] # right
    ]
    vertical_directions = [
      [0, -1], # down
      [0, 1] # up
    ]

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

  def valid_knight_moves(spot, board)
    moves = []
    b = board
    x = spot.row
    y = spot.column
    piece_class = spot.piece.piece_id
    possible_spots = [
      [x - 2, y - 1], [x - 2, y + 1],
      [x - 1, y - 2], [x - 1, y + 2],
      [x + 1, y - 2], [x + 1, y + 2],
      [x + 2, y - 1], [x + 2, y + 1]
    ]
    # check if all the possible spots are within the board and don't contain any friendly piece
    possible_spots.each do |move|
      row, col = move
      if row.between?(0, 7) && col.between?(0, 7)
        move_spot = b[row][col]
        moves << [move_spot.row, move_spot.column] if move_spot.empty? || enemy_piece?(self, move_spot.piece)
      end
    end
    moves
  end

  # generates valid moves for bishop
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
