# frozen_string_literal: true

# lib/pawn.rb

require_relative 'chessboard'
require_relative 'pieces'
require_relative 'pawn_module'
# Pawn class
class Pawn < Piece
  include PawnModule
  attr_accessor :can_be_promoted, :moved_two_spots

  def initialize(piece_id)
    super(piece_id)
    @can_be_promoted = false
    @moved_two_spots = false
  end
end
