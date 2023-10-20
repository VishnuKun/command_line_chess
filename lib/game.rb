# frozen_string_literal: true

# lib/game.rb

require_relative 'pieces'
require_relative 'chessboard'
require_relative 'player'
require_relative 'game_module'

# Game
class Game
  include GameModule
  include KingModule
  include PawnModule
  include PieceModule
  attr_accessor :game_board, :current_player, :player1, :player2, :fifty_move_rule_counter

  @@previous_board_states = []

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

  # starts the game
  def play_game
    # if state file exists then ask user would they like to continue the last game where they left?
    if File.exist?('game_state.sav')
      puts 'A game state file exists! Would you like to continue the game from where you left it? '
      puts 'Or start a new game?'
      print "Type 'y' to continue the previous game' or 'n' to start a new game : "
      response = gets.chomp.strip
      loop do
        if response == 'y'
          load_board('game_state.sav')
          loaded_data = Marshal.load(File.read('game_state.sav'))

          # Set player names from the loaded data
          @player1.name = loaded_data[:player1_name]
          @player2.name = loaded_data[:player2_name]

          # Set the game board
          @game_board = loaded_data[:game_board]
          break
        elsif response == 'n'
          delete_state_files('game_state.sav')
          break
        else
          puts "Error invalid response: #{response}"
          puts 'Please enter y or n only.'
          print "Type 'y' to continue the previous game' or 'n' to start a new game : "
          response = gets.chomp.strip
        end
      end
    else
      puts 'No game state file found. Starting a new game...'
    end
    start_game

    # add condition asking user if they want to go another round
    loop do
      puts 'Would you like to play again?'
      print "Type 'yes' or 'no' to continue : "
      response = gets.chomp
      if response.downcase == 'yes'
        initialize
        start_game
      elsif response.downcase == 'no'
        break
      else
        puts "Invalid response! Please enter 'yes' or 'no' only!"
      end
    end
  end

  # Starts a new game
  def start_game
    introduction
    puts
    # If player names are not loaded from the saved game, ask for player names
    ask_player_names if @player1.name.nil? || @player2.name.nil?
    print_board(@game_board)

    @current_player = @player1
    loop do
      # check for game over condition
      if (game_over_result = game_over?)
        display_game_result(game_over_result[:result])
        puts "Reason: #{game_over_result[:reason]}"
        break
      end
      # ask current player to select their choice of piece
      target = get_valid_target_square(@current_player)
      # condition for saving the game state
      if target == 'save'
        save_board('game_state.sav')
        break
      end
      # when player resigns
      if target == 'resign'
        opponent = current_player == player1 ? player2 : player1
        puts "#{current_player.name} has resigned."
        puts "#{opponent.name} wins!"
        break
      end
      # when both agree to draw
      if target == 'agree'
        opponent = current_player == player1 ? player2 : player1
        puts "#{current_player.name} proposes a draw."
        print "#{opponent.name}, do you agree to the draw? Type 'yes' or 'no': "
        response = gets.chomp.downcase
        if response == 'yes'
          puts 'The game ends in a draw by mutual agreement.'
          break
        elsif response == 'no'
          puts "#{opponent.name} does not agree to the draw. The game continues."
          next
        else
          puts "Invalid response. Please type 'yes' or 'no'."
        end
      end

      row = target[0]
      column = target[1]
      piece = @game_board[row][column].piece
      # check if a piece exists in the given location
      if piece.nil?
        puts "You can't choose empty square!"
        next
      end
      # check if the piece selected belongs to the current player only
      # current player shouldn't be able to choose enemy piece
      if piece.color != @current_player.controls_pieces
        puts "You can't choose enemy piece!"
        next
      end
      # check is locked or not
      moves = piece.valid_moves(@game_board)
      if moves.empty?
        puts "#{piece.symbol} is locked or has no possible moves" unless piece.nil?
        puts "The chosen square at #{target} has no piece." if piece.nil?
        puts 'Please select another square instead of previous one.'
        next
      end
      # ask current player to select their choice of square to move piece into
      location = get_valid_destination_square(piece, @current_player, moves)
      # when player resigns
      if location == 'resign'
        opponent = current_player == player1 ? player2 : player1
        puts "#{current_player.name} has resigned."
        puts "#{opponent.name} wins!"
        break
      end
      # when both agree to draw
      if location == 'agree'
        opponent = current_player == player1 ? player2 : player1
        puts "#{current_player.name} proposes a draw."
        print "#{opponent.name}, do you agree to the draw? Type 'yes' or 'no': "
        response = gets.chomp.downcase
        if response == 'yes'
          puts 'The game ends in a draw by mutual agreement.'
          break
        elsif response == 'no'
          puts "#{opponent.name} does not agree to the draw. The game continues."
          next
        else
          puts "Invalid response. Please type 'yes' or 'no'."
        end
      end
      # condition for saving the game state
      if location == 'save'
        save_board('game_state.sav')
        break
      end

      loc_row = location[0]
      loc_column = location[1]

      # add 1 to fifty_move_rule_counter if -
      # its not a pawn
      # and not a capture move
      @fifty_move_rule_counter += 1 if !piece.is_a?(Pawn) && @game_board[loc_row][loc_column].empty?
      # move the piece into the destination square
      piece.move_to(loc_row, loc_column, @game_board)
      # if its a pawn and it has reached top
      # turn promotion variable to true
      if piece.is_a?(Pawn)
        piece.can_be_promoted = true if piece.color == 'white' && loc_row == 7
        piece.can_be_promoted = true if piece.color == 'black' && loc_row.zero?
      end
      # handle promotion case
      if piece.is_a?(Pawn) && piece.can_be_promoted
        # ask for key for promotion
        key = piece.get_promotion_instance_id
        # perform promotion
        piece.promote_to(key, @game_board)
      end
      # print the board right after to show movement
      print_board(@game_board)

      # if game_over_result = game_over?
      #   display_game_result(game_over_result[:result])
      #   puts "Reason: #{game_over_result[:reason]}"
      #   break
      # end
      # update current player accordingly
      @current_player = if @current_player == @player1
                          @player2
                        else
                          @player1
                        end
    end
  end

  # Helper method to get a valid target square from the user
  def get_valid_target_square(current_player)
    print "#{current_player.name} enter piece's location => "
    target = gets.chomp.strip
    return target if target.downcase == 'save'
    return target if target.downcase == 'resign'
    return target if target.downcase == 'agree'

    loop do
      break if valid_user_input?(target)

      puts 'Invalid input! Square must have a piece in it.'
      print "#{current_player.name} enter piece's location => "
      target = gets.chomp.strip
    end
    # return location in [row, column] format
    convert_alphanumeric_to_indices(target)
  end

  # Helper method to get a valid destination square from the user
  def get_valid_destination_square(piece, current_player, possible_moves)
    print "#{current_player.name} move '#{piece.symbol} ' to =>  "
    destination = gets.chomp.strip
    return destination if destination.downcase == 'save'
    return destination if destination.downcase == 'resign'
    return destination if destination.downcase == 'agree'

    # check if response is empty
    loop do
      break if destination != ''

      puts 'Invalid response, please try again.'
      print "#{current_player.name} move '#{piece.symbol} ' to =>  "
      destination = gets.chomp.strip
    end
    destination = convert_alphanumeric_to_indices(destination)
    loop do
      break if possible_moves.include?(destination)

      puts 'Invalid location selected! Please enter a valid destination.'
      print "#{current_player.name} move '#{piece.symbol} ' to =>  "
      destination = gets.chomp.strip
      destination = convert_alphanumeric_to_indices(destination)
    end
    destination
  end

  # convert's the input given by user into indices returns array containing row and column
  def convert_alphanumeric_to_indices(value)
    string = value.chars
    row = string[1].to_i - 1
    column = string[0].downcase
    # update the column as per alphabet
    case column
    when 'a'
      column = 0
    when 'b'
      column = 1
    when 'c'
      column = 2
    when 'd'
      column = 3
    when 'e'
      column = 4
    when 'f'
      column = 5
    when 'g'
      column = 6
    when 'h'
      column = 7
    end
    [row, column]
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
      puts "#{player1.name} will control the #{player1.controls_pieces} pieces."

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
      puts "#{player2.name} will control the #{player2.controls_pieces} pieces."

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

  # Update the game_over? method in your Game class
  def game_over?
    return { result: :checkmate, reason: 'Checkmate' } if check_mate?
    return { result: :stalemate, reason: 'Stalemate' } if stale_mate?
    return { result: :fifty_move_rule, reason: 'Fifty-move rule' } if fifty_move_rule?
    return { result: :repetition, reason: 'Repetition' } if repetition?
    return { result: :insufficient_material, reason: 'Insufficient material' } if insufficient_material?

    false
  end

  # Add this method to your Game class
  def display_game_result(result)
    case result
    when :checkmate
      # when current player checkmates i.e. wins
      loser = current_player
      winner = current_player == player1 ? player2 : player1
      # when current player gets check mated i.e. losts

      puts "#{winner.name} checkmated #{loser.name}!"
      puts "#{winner.name} wins!"
    when :stalemate
      puts 'Its a Draw!'
    when :fifty_move_rule
      puts 'Its a Draw!'
    when :repetition
      puts 'Its a Draw!'
    when :insufficient_material
      puts 'Its a Draw!'
    end
  end

  # checks if current player's king is in check and has no legal moves
  def check_mate?
    current_player_color = @current_player.controls_pieces
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

    true
  end

  # checks if current player's king isn't in check and has no legal moves
  def stale_mate?
    current_player_color = @current_player.controls_pieces
    board = @game_board

    # Find the current player's king
    king = nil
    king_row = nil
    king_column = nil

    board.each_with_index do |row, row_index|
      row.each_with_index do |spot, column_index|
        next unless spot.piece.is_a?(King) && spot.piece.color == current_player_color

        king = spot.piece
        king_row = row_index
        king_column = column_index
        break
      end
    end
    # If the king is in check, it's not a stalemate
    return false if in_check?(king, board, king_row, king_column)

    # Iterate through all the player's pieces and check for legal moves
    player_pieces = board.flatten.select { |spot| spot.piece && spot.piece.color == current_player_color }

    player_pieces.each do |spot|
      piece = spot.piece
      moves = piece.valid_moves(board)
      return false unless moves.empty?
    end

    # If no player pieces have legal moves, it's a stalemate
    true
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

    # Check if the current position has occurred two times before
    return true if @@previous_board_states.count(current_board_state) >= 2

    # Else, add the current state to previous board states
    @@previous_board_states << current_board_state
    false
  end

  # ...

  # Implement the game_board_to_string method
  def game_board_to_string
    @game_board.map do |row|
      row.map do |spot|
        spot.piece.nil? ? ' ' : spot.piece.symbol.to_s
      end.join('')
    end.join('/')
  end

  # ...

  # Add a method to reset the previous_board_states
  def self.reset_previous_board_states
    @@previous_board_states = []
  end

  # Convert the game board to a string representation
  def game_board_to_string
    @game_board.map do |row|
      row.map do |spot|
        spot.piece.nil? ? ' ' : spot.piece.symbol.to_s
      end.join('')
    end.join('/')
  end

  def insufficient_material?
    white_material = material_count('white')
    black_material = material_count('black')

    white_material <= 1 && black_material <= 1
  end

  def material_count(color)
    material = 0
    board = @game_board

    board.each do |row|
      row.each do |spot|
        piece = spot.piece
        next unless piece && piece.color == color

        material += case piece.symbol
                    when '♔', '♛', '♘'
                      1
                    when '♚', '♟'
                      1
                    else
                      0
                    end
      end
    end

    material
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
