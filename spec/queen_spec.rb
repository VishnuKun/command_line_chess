# frozen_string_literal: true

# spec/queen_spec.rb

require 'spec_helper'
require 'pieces'
require 'chessboard'

describe Queen do
  describe '#valid_moves' do
    context 'when the Queen is placed at position (0, 0) on an empty chessboard' do
      subject(:queen) { described_class.new(5) }
      subject(:chess_board) { Chessboard.new }

      before do
        chess_board.add_piece(queen, 0, 0)
      end

      it 'returns the correct number of moves' do
        expect(queen.valid_moves).to contain_exactly(
          [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
          [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
          [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]
        )
      end
    end

    context 'when an eneymy piece is on the on the way of the queen' do
      subject(:queen) { described_class.new(5) }
      subject(:pawn) { Piece.new(-1) }
      subject(:chess_board) { Chessboard.new }

      before do
        chessboard.add_piece(pawn, 3, 3)
        chessboard.add_piece(queen, 5, 5)
      end

      it 'returns the correct number of moves' do
        expect(queen.valid_moves).to contain_exactly(
          [5, 0], [5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [5, 7],
          [0, 5], [1, 5], [2, 5], [3, 5], [4, 5], [5, 6], [6, 5], [7, 5],
          [3, 3], [4, 4], [6, 6], [7, 7],
          [3, 7], [4, 6], [6, 4], [7, 3]
        )
      end
    end
  end
end
