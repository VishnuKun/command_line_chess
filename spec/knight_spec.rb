# frozen_string_literal: true

# spec/knight_spec.rb

require 'spec_helper'
require 'pieces'
require 'chessboard'

describe Knight do
  describe '#valid_moves' do
    context 'when knight is at (3, 4) on empty chessboard' do
      subject(:knight) { described_class.new(2) }
      subject(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(knight, 3, 4)
      end
      it 'returns correct number of moves' do
        expect(knight.valid_moves).to contain_exactly(
          [1, 3], [1, 5], [2, 2], [2, 6], [4, 2], [4, 6], [5, 3], [5, 5]
        )
      end
    end

    context 'when knight is at (3, 4) on empty chessboard with an enemy pawn at (5, 5)' do
      subject(:knight) { described_class.new(2) }
      subject(:pawn) { Pawn.new(1) }
      subject(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(knight, 3, 4)
        chess_board.add_piece(pawn, 5, 5)
      end
      it 'returns correct number of moves' do
        expect(knight.valid_moves).to contain_exactly(
          [1, 3], [1, 5], [2, 2], [2, 6], [4, 2], [4, 6], [5, 3]
        )
      end
    end
  end
end
