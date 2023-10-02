# frozen_string_literal: true

# lib/pieces.rb

require_relative 'chessboard'

class Piece
    attr_accessor :piece_id

    def initialize(piece_id)
        @piece_id = piece_id
    end
end