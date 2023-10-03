# frozen_string_literal: true

# lib/pieces.rb

require_relative 'chessboard'

class Piece
  attr_accessor :piece_id, :captured, :moved

  def initialize(piece_id)
    @piece_id = piece_id
    @captured = false
    @moved = false
  end

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
end
