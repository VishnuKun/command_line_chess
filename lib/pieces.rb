# frozen_string_literal: true

# lib/pieces.rb

require_relative 'pawn'
require_relative 'knight'
require_relative 'bishop'
require_relative 'rook'
require_relative 'queen'
require_relative 'king'
require_relative 'chessboard'

class Piece
  attr_accessor :piece_id, :captured, :moved, :symbol , :color

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
    piece_id.negative? ? 'black' : 'white'
  end
end
