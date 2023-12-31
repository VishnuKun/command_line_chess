# frozen_string_literal: true

# lib/pieces.rb
require_relative 'pieces_module'

# Piece
class Piece
  include PieceModule
  attr_accessor :piece_id, :captured, :moved, :symbol, :color

  def initialize(piece_id)
    @piece_id = piece_id
    @captured = false
    @moved = false
    @symbol = set_symbol(piece_id)
    @color = set_color(piece_id)
  end

  # create a new piece with the given piece identifier
  def self.create_piece(piece_id)
    case piece_id
    when 1, -1
      Pawn.new(piece_id)
    when 2, -2
      Knight.new(piece_id)
    when 3, -3
      Bishop.new(piece_id)
    when 4, -4
      Rook.new(piece_id)
    when 5, -6
      Queen.new(piece_id)
    when 6, -5
      King.new(piece_id)
    else
      raise ArgumentError, "Invalid piece id: #{piece_id}"
    end
  end

  # moves the piece to the given position
  def move_to(row, column, board)
    current_piece = self
    current_spot = find_spot(current_piece, board)
    # handle diagonal movement of pawn during en-passant
    if current_piece.instance_of?(Pawn) && current_piece.en_passant_possible?(row, column, board)
      return current_piece.en_passant(row, column, board)
    end

    # handle castling
    if current_piece.is_a?(King) && (column - current_spot.column).abs == 2
      return castle_left(board) if column < current_spot.column
      return castle_right(board) if column > current_spot.column
    end

    current_spot.piece = nil
    current_piece.moved = true
    destination = board[row][column]
    return unless destination.empty? || current_piece.color != destination

    destination.piece.captured = true if destination.piece && current_piece.color != destination.piece.color

    destination.piece = current_piece
    # handle double step case
    return unless current_piece.is_a?(Pawn) && (destination.row - current_spot.row).abs == 2

    current_piece.moved_two_spots = true
  end

  def capture_at(row, column, board)
    current_piece = self
    current_spot = find_spot(current_piece, board)
    target_spot = board[row][column]
    enemy_piece = target_spot.piece
    return unless current_piece.color != enemy_piece.color

    target_spot.piece = nil
    current_spot.piece = nil
    enemy_piece.captured = true
    target_spot.piece = current_piece
  end
end

# Knight
class Knight < Piece
end

# Bishop
class Bishop < Piece
end

# Rook
class Rook < Piece
end

# Queen
class Queen < Piece
end

require_relative 'pawn'
require_relative 'king'
require_relative 'chessboard'
