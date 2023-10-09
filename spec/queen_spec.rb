# frozen_string_literal: true

# spec/queen_spec.rb

require 'spec_helper'
require 'pieces'
require 'chessboard'

describe Queen do
  describe '#valid_moves' do
    context 'when the Queen is placed at position (0, 0) on an empty chessboard' do
      subject(:queen) { described_class.new(5) }
      let(:chess_board) { Chessboard.new }

      before do
        chess_board.add_piece(queen, 0, 0)
      end

      it 'returns the correct number of moves' do
        expect(queen.valid_moves(chess_board.board_array)).to contain_exactly(
          [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
          [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
          [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]
        )
      end
    end

    context 'when queen is at (5, 5) and enemy pawn is at (3, 3)' do
      subject(:queen) { described_class.new(5) }
      let(:pawn) { Piece.new(-1) }
      let(:chess_board) { Chessboard.new }

      before do
        chess_board.add_piece(pawn, 3, 3)
        chess_board.add_piece(queen, 5, 5)
      end

      it 'returns the correct number of moves' do
        expect(queen.valid_moves(chess_board.board_array)).to contain_exactly(
          [5, 0], [5, 1], [5, 2], [5, 3], [5, 4], [5, 6], [5, 7],
          [0, 5], [1, 5], [2, 5], [3, 5], [4, 5], [6, 5], [7, 5],
          [3, 3], [4, 4], [6, 6], [7, 7],
          [3, 7], [4, 6], [6, 4], [7, 3]
        )
      end
    end
  end
end
