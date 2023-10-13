# frozen_string_literal: true

# lib/game.rb

require_relative 'pieces'
require_relative 'chessboard'
require_relative 'player'

# Game
class Game
  include KingModule
  include PieceModule
  attr_accessor :game_board, :current_player, :player1, :player2, :fifty_move_rule_counter

  # Initializes board state
  def initialize
    chessboard = Chessboard.new
    @game_board = chessboard.board_array
    create_initial_board_state
    @current_player = nil
    @player1 = Player.new('white')
    @player2 = Player.new('black')
    @fifty_move_rule_counter = 0
  end

  # sets player names for instances
  def ask_player_names
    loop do
      print 'Enter name for Player 1: '
      player1.name = gets.chomp.strip

      if player1.name.empty?
        puts 'Name cannot be empty. Please try again.'
        next
      end

      break
    end
    loop do
      print 'Enter name for Player 2: '
      player2.name = gets.chomp.strip

      if player2.name.empty?
        puts 'Name cannot be empty. Please try again.'
        next
      end
      if player2.name == player1.name
        puts 'Name cannot be same. Please try again.'
        next
      end

      break
    end
  end

  # creates boards initial state for gameplay
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

  # check if the game is over or not
  def game_over?
    if check_mate? || stale_mate? || fifty_move_rule? || repetition? || insufficient_material? || win? || lose? || draw?
      return true
    end

    false
  end

  # checks if current player's king is in check and has no legal moves
  def check_mate?
    current_player_color = current_player.controls_pieces
    board = @game_board
    king = nil
    king_row = nil # king row
    king_column = nil # king column
    # find current player's king as per color
    board.each_with_index do |row, row_index|
      row.each_with_index do |spot, column_index|
        next unless spot.piece.is_a?(King) && spot.piece.color == current_player_color

        king = spot.piece
        king_row = row_index
        king_column = column_index
        break
      end
    end
    # ! Current player's king must be in check
    return false unless in_check?(king, board, king_row, king_column)
    # ! Current player's king must have 0 valid moves
    return false unless king.valid_moves(board) == []

    false
  end

  # checks if current player's king isn't in check and has no legal moves
  def stale_mate?
    current_player_color = current_player.controls_pieces
    board = @game_board
    king = nil
    row = nil # king row
    column = nil # king column
    # find current player's king as per color
    board.each_with_index do |row, row_index|
      row.each_with_index do |spot, column_index|
        king = spot.piece if spot.piece.is_a?(King) && spot.piece.color == current_player_color
        row = row_index
        column = column_index
      end
    end
    # ! Current player's king must not be in check
    return false if in_check?(king, board, row, column)
    # ! Current player's king must have 0 valid moves
    return false unless king.valid_moves(board) == []

    false
  end

  # checks there's no capture or no pawn movement for 50  consecutive moves
  def fifty_move_rule?
    counter = @fifty_move_rule_counter
    return true if counter >= 50

    false
  end

  # checks if the current position has been repeated three times
  def repetition?
    current_board_state = game_board_to_string
    # store previous board states
    previous_board_states = []
    # convert current board state to string representation
    # check if the current positions has occured two times before
    return true if previous_board_states.count(current_board_state) >= 2

    # else add current state to previous board states
    previous_board_states << current_board_state
    false
  end

  # Convert the game board to a string representation
  def game_board_to_string
    @game_board.map do |row|
      row.map do |spot|
        spot.piece.nil? ? ' ' : spot.piece.to_s
      end.join('')
    end.join('/')
  end

  # checks if there are insufficent pieces for a checkmate
  def insufficient_material?
    # check the number of pieces for both the players
    white_pieces = 0
    black_pieces = 0

    current_player_color = current_player.controls_pieces
    board = @game_board
    # find current player's king as per color
    board.each do |row|
      row.each do |spot|
        # count enemy pieces
        white_pieces += 1 if spot.piece && spot.piece.color != current_player_color
        # count current player pieces
        black_pieces += 1 if spot.piece && spot.piece.color == current_player_color
      end
    end

    # when current player has more pieces then enemy
    return true if black_pieces <= white_pieces && white_pieces == 1
    # when enemy player has more pieces then current player
    return true if white_pieces <= black_pieces && black_pieces == 1

    false
  end

  # checks if the current player has won
  def win?
    # find enemy player's king and check if its captured or not
    current_player_color = current_player.controls_pieces
    board = @game_board
    enemy_king = nil
    # find current player's king as per color
    board.each do |row|
      row.each do |spot|
        enemy_king = spot.piece if spot.piece.is_a?(King) && spot.piece.color != current_player_color
      end
    end
    return true if check_mate?

    false
  end

  # checks if the current player has lost
  def lose?
    # find current player's king and check if its captured or not
    current_player_color = current_player.controls_pieces
    board = @game_board
    current_player_king = nil
    # find current player's king as per color
    board.each do |row|
      row.each do |spot|
        current_player_king = spot.piece if spot.piece.is_a?(King) && spot.piece.color != current_player_color
      end
    end
    return true if check_mate?

    false
  end

  # checks if the match is a draw
  def draw?
    return true if stale_mate? || repetition? || fifty_move_rule? || insufficient_material?

    false
  end
end
