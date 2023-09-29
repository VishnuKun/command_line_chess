# frozen_string_literal: true

# spec/queen_spec.rb

require 'spec_helper'
require 'pieces'
require 'chessboard'

describe Bishop do
  describe '#valid_moves' do
    context 'when the Bishop is at corner (0, 7) on an empty board' do
      subject(:bishop) { described_class.new(3) }
      subject(:chess_board) { Chessboard.new }

      before do
        chess_board.add_piece(bishop, 0, 7)
      end
      it 'returns the correct number of moves' do
        expect(bishop.valid_moves).to contain_exactly(
          [1, 6], [2, 5], [3, 4], [4, 3], [5, 2], [6, 1], [7, 0]
        )
      end
    end

    context 'when the bishop is at (4, 4) with enemy piece at (6, 2)' do
      subject(:bishop) { described_class.new(3) }
      subject(:enemy_pawn) { described_class.new(-1) }
      subject(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(bishop, 4, 4)
        chess_board.add_piece(enemy_pawn, 6, 2)
      end
      it 'returns the correct number of moves' do
        expect(bishop.valid_moves).to contain_exactly(
          [0, 0], [1, 1], [2, 2], [3, 3], [5, 5], [6, 6], [7, 7],
          [1, 7], [2, 6], [3, 5], [5, 3], [6, 2]
        )
      end
    end
  end
end
