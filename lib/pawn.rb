# frozen_string_literal: true

# lib/pawn.rb

require_relative 'chessboard'
require_relative 'pieces'
# Pawn class
class Pawn < Piece
  attr_accessor :can_be_promoted, :moved_two_spots

  def initialize(piece_id)
    super(piece_id)
    @can_be_promoted = false
    @moved_two_spots = false
  end

  # performs en-passant action
  def en_passant(row, column, board)
    killer_pawn = self
    direction = killer_pawn.color == 'white' ? -1 : 1
    current_spot = find_spot(killer_pawn, board)
    en_passant_spot = board[current_spot.row + direction][current_spot.column]
    killed_pawn = en_passant_spot.piece
    return unless killed_pawn && killed_pawn.moved_two_spots
    return unless killed_pawn.is_a?(Pawn) && killed_pawn.color != killer_pawn.color

    # capture target pawn
    killed_pawn.captured = true
    en_passant_spot.piece = nil
    # remove your piece from its original spot
    current_spot.piece = nil
    # place your piece on the diagonal spot
    diagonal_spot = board[row][column]
    diagonal_spot.piece = killer_pawn
  end

  # promotes the pawn to desired position
  def promote_to(instance_id, board)
    current_piece = self
    current_spot = find_spot(current_piece, board)
    current_spot.piece = nil
    promoted_piece = Piece.create_piece(instance_id)
    current_spot.piece = promoted_piece
  end

  # returns the valid spots for the current pawn instance where it can be moved to
  def valid_pawn_moves(spot, board)
    moves = []
    x = spot.row
    y = spot.column
    b = board
    pawn = spot.piece
    direction = pawn.color == 'white' ? -1 : 1

    # check if the pawn has already moved
    if (x + (2 * direction)).between?(0, 7) && !pawn.moved
      forward_double = b[x + (2 * direction)][y]
      moves << [forward_double.row, forward_double.column] if forward_double.empty? && b[x + direction][y].empty?
    end

    # check for the forward single move
    if (x + direction).between?(0, 7)
      forward_single = b[x + direction][y]
      moves << [forward_single.row, forward_single.column] if forward_single.empty?
    end

    # check for the left diagonal move
    if y.positive? && (x + direction).between?(0, 7)
      left_diagonal = b[x + direction][y - 1]
      moves << [left_diagonal.row, left_diagonal.column] if left_diagonal.piece && enemy_piece?(pawn,
                                                                                                left_diagonal.piece)
    end

    # check for the right diagonal move
    if (y < b[x].length - 1) && (x + direction).between?(0, 7)
      right_diagonal = b[x + direction][y + 1]
      moves << [right_diagonal.row, right_diagonal.column] if right_diagonal.piece && enemy_piece?(pawn,
                                                                                                   right_diagonal.piece)
    end

    # Check if the pawn has reached the farthest point and ready for promotion
    pawn.can_be_promoted = true if x == 7 # white pawn promotion
    pawn.can_be_promoted = true if x.zero? # black pawn promotion
    moves
  end
end
