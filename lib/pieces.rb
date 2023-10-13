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
    # make the current spot.piece = nil
    current_spot = find_spot(current_piece, board)
    current_spot.piece = nil
    current_piece.moved = true
    # find the destination spot
    destination = board[row][column]
    # check if the desination isn't inhabited by friendly piece
    return unless destination.empty? || current_piece.color != destination

    # capture enemy piece if present
    destination.piece.captured = true if destination.piece && current_piece.color != destination.piece.color

    # make the destination_spot.piece = piece
    destination.piece = current_piece
    # handle en_passant case
    return unless current_piece.is_a?(Pawn) && (destination.row - current_spot.row).abs == 2

    current_piece.moved_two_spots = true
  end

  # captures the enemy piece at the given position
  def capture_at(row, column, board)
    current_piece = self
    current_spot = find_spot(current_piece, board)
    target_spot = board[row][column]
    enemy_piece = target_spot.piece
    # performs only when there's enemy piece on target spot
    return unless current_piece.color != enemy_piece.color

    # remove the enemy piece from the spot
    target_spot.piece = nil
    # remove the your piece from the original spot
    current_spot.piece = nil
    # mark it(captured piece) as captured
    enemy_piece.captured = true
    # place your piece on the spot
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
