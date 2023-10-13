# frozen_string_literal: true

# lib/king.rb

require_relative 'pieces'
require_relative 'chessboard'
require_relative 'king_module'
# King
class King < Piece
  include KingModule
end
