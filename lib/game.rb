# frozen_string_literal: true

# lib/game.rb

require_relative 'pieces'
require_relative 'chessboard'

# Game
class Game
  attr_accessor :game_board

  # Initializes board state
  def initialize
    chessboard = Chessboard.new
    @game_board = chessboard.board_array
    create_initial_board_state
  end

  # creates and places piece instances in spots of the board array
  def create_initial_board_state
    board = @game_board
    # for placing pawns
    row_two = board[1] # for white pawns
    row_three = board[6] # for black pawns

    # setting pawns
    row_two.each { |spot| spot.piece = Piece.create_piece(-1) } # white pawns
    row_three.each { |spot| spot.piece = Piece.create_piece(1) } # black pawns

    # setting rooks
    board[0][0].piece = Piece.create_piece(-4) # white rook left
    board[0][7].piece = Piece.create_piece(-4) # white rook right
    board[7][0].piece = Piece.create_piece(4) # black rook left
    board[7][7].piece = Piece.create_piece(4) # black rook right

    # setting knights
    board[0][1].piece = Piece.create_piece(-2) # white knight left
    board[0][6].piece = Piece.create_piece(-2) # white knight right
    board[7][1].piece = Piece.create_piece(2) # black knight left
    board[7][6].piece = Piece.create_piece(2) # black knight right

    # setting bishops
    board[0][2].piece = Piece.create_piece(-3) # white bishop left
    board[0][5].piece = Piece.create_piece(-3) # white bishop right
    board[7][2].piece = Piece.create_piece(3) # black bishop left
    board[7][5].piece = Piece.create_piece(3) # black bishop right

    # setting queens
    board[0][3].piece = Piece.create_piece(-6) # white queen left
    board[7][3].piece = Piece.create_piece(5) # black queen left

    # setting kings
    board[0][4].piece = Piece.create_piece(-5) # white king right
    board[7][4].piece = Piece.create_piece(6) # black king right
  end
end
