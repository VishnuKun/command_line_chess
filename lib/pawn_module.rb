# frozen_string_literal: true

# lib/pawn_module.rb

# contains methods for pawn
module PawnModule
  # performs en-passant action
  def en_passant(row, column, board)
    piece = self
    # find piece's spot
    piece_spot = find_spot(piece, board)
    # find enemy piece and its spot
    # ! give row from piece and column from destination
    en_passant_spot = board[piece_spot.row][column]
    # get enemy piece
    killed_pawn = en_passant_spot.piece
    # check if en passant is possible or not
    return unless en_passant_possible?(row, column, board)

    # capture target pawn
    killed_pawn.captured = true
    en_passant_spot.piece = nil
    # remove your piece from its original spot
    piece_spot.piece = nil
    # place your piece on the diagonal spot
    destination = board[row][column]
    destination.piece = piece
  end

  # checks if en passant is possible
  def en_passant_possible?(_row, column, board)
    piece = self
    piece_spot = find_spot(piece, board)
    en_passant_spot = board[piece_spot.row][column]
    killed_pawn = en_passant_spot.piece

    return false unless killed_pawn&.moved_two_spots
    return false unless killed_pawn.is_a?(Pawn) && killed_pawn.color != piece.color

    true
  end

  # promotes the pawn to desired position
  def promote_to(instance_id, board)
    current_piece = self
    current_spot = find_spot(current_piece, board)
    current_spot.piece = nil
    promoted_piece = Piece.create_piece(instance_id)
    current_spot.piece = promoted_piece
  end

  # helper method for promotion
  def get_promotion_instance_id
    pawn = self
    instance_id = nil
    puts 'Promotion is available for the pawn!'
    puts 'Promotion Keys :- Knight => 1, Bishop => 2, Rook => 3, Queen => 4'
    print 'Please enter promotion key : '
    response = gets.chomp
    # check if the response is valid or not
    loop do
      break if response.to_i.between?(1, 4)

      puts 'Invalid number selected! Please select among the given only.'
      print 'Please enter promotion key : '
      response = gets.chomp
    end
    # convert the response into proper id according to color
    case response.to_i
    when 1 # Knight
      instance_id = pawn.color == 'white' ? -2 : 2
    when 2 # Bishop
      instance_id = pawn.color == 'white' ? -3 : 3
    when 3 # Rook
      instance_id = pawn.color == 'white' ? -4 : 4
    when 4 # Queen
      instance_id = pawn.color == 'white' ? -6 : 5
    end
    instance_id
  end

  # returns the valid spots for the current pawn instance where it can be moved to
  def valid_pawn_moves(spot, board)
    moves = []
    x = spot.row
    y = spot.column
    b = board
    pawn = spot.piece
    direction = pawn.color == 'black' ? -1 : 1

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
      moves << [left_diagonal.row, left_diagonal.column] if pawn.en_passant_possible?(left_diagonal.row,
                                                                                      left_diagonal.column, board)
    end

    # check for the right diagonal move
    if (y < b[x].length - 1) && (x + direction).between?(0, 7)
      right_diagonal = b[x + direction][y + 1]
      # add the right diagonal move if enemy piece is present or when en-passant is possible
      moves << [right_diagonal.row, right_diagonal.column] if right_diagonal.piece && enemy_piece?(pawn,
                                                                                                   right_diagonal.piece)
      moves << [right_diagonal.row, right_diagonal.column] if pawn.en_passant_possible?(right_diagonal.row,
                                                                                        right_diagonal.column, board)
    end

    # Check if the pawn has reached the farthest point and ready for promotion
    pawn.can_be_promoted = true if x == 7 # white pawn promotion
    pawn.can_be_promoted = true if x.zero? # black pawn promotion
    moves
  end
end
