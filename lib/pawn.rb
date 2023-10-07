# frozen_string_literal: true

# lib/pawn.rb

require_relative 'chessboard'
require_relative 'pieces'

class Pawn < Piece
  def initialize(piece_id)
    super(piece_id)
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
    direction = pawn.color == 'white' ? -1 : 1 # -1 for upwards and 1 for downwards
    
    # check if the pawn has already moved
    if (x + direction).between?(0, 7)
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
end
