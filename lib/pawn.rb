# frozen_string_literal: true

# lib/pawn.rb

require_relative 'chessboard'
require_relative 'pieces'

class Pawn < Piece
  attr_accessor :can_be_promoted
  def initialize(piece_id)
    super(piece_id)
    @can_be_promoted = false
  end

  # performs en-passant action
  def en_passant(x, y)
    return nil
  end

  # promotes the pawn to desired position
  def promote_to(instance)
    return nil
  end
  
  # returns the valid spots for the current pawn instance where it can be moved to
  def valid_pawn_moves(spot, board)
    moves = []
    x = spot.row
    y = spot.column
    b = board
    pawn = spot.piece
    pawn_color = pawn.color
    direction = pawn.color == 'white' ? -1 : 1 
    
    # check if the pawn has already moved
    if (x + (2 * direction)).between?(0, 7)
      if not pawn.moved
        forward_double = b[x + (2 * direction)][y]
        if forward_double.empty? and b[x+ direction][y].empty?
          moves << forward_double
        end
      end
    end
    
    # check for the forward single move
    if (x + direction).between?(0, 7)
      forward_single = b[x + direction][y]
      if forward_single.empty?
        moves << forward_single
      end
    end

    # check for the left diagonal move
    if y > 0 && (x + direction).between?(0,7)
      left_diagonal = b[x + direction][y - 1]
      if left_diagonal.piece && enemy_piece?(pawn, left_diagonal.piece)
        moves << left_diagonal
      end
    end
    
    # check for the right diagonal move
    if (y < b[x].length - 1) && (x + direction).between?(0,7)
      right_diagonal = b[x + direction][y + 1]
      if right_diagonal.piece && enemy_piece?(pawn, right_diagonal.piece)
        moves << right_diagonal
      end
    end

    # Check if the pawn has reached the farthest point and ready for promotion
    if x == 7 && direction == 1 
      puts "White Pawn Promotion available!" 
      pawn.can_be_promoted = true
    end
    
    if x == 0 && direction == -1
      puts "Black Pawn Promotion available!" 
      pawn.can_be_promoted = true
    end

    return moves
  end
end
