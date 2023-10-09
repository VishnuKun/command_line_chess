# frozen_string_literal: true

# spec/bishop_spec.rb

require 'spec_helper'
require 'pieces'
require 'chessboard'

describe Bishop do
  describe '#valid_moves' do
    context 'when the Bishop is at corner (0, 7) on an empty board' do
      subject(:bishop) { described_class.new(3) }
      let(:chess_board) { Chessboard.new }

      before do
        chess_board.add_piece(bishop, 0, 7)
      end
      it 'returns the correct number of moves' do
        board = chess_board.board_array
        expect(bishop.valid_moves(board)).to contain_exactly(
          [1, 6], [2, 5], [3, 4], [4, 3], [5, 2], [6, 1], [7, 0]
        )
      end
    end

    context 'when the bishop is at (4, 4) with enemy piece at (6, 2)' do
      subject(:bishop) { described_class.new(3) }
      let(:enemy_pawn) { described_class.new(-1) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(bishop, 4, 4)
        chess_board.add_piece(enemy_pawn, 6, 2)
      end
      it 'returns the correct number of moves' do
        board = chess_board.board_array
        expect(bishop.valid_moves(board)).to contain_exactly(
          [0, 0], [1, 1], [2, 2], [3, 3], [5, 5], [6, 6], [7, 7],
          [1, 7], [2, 6], [3, 5], [5, 3], [6, 2]
        )
      end
    end

    context 'when the bishop is at (4, 7) on empty board' do
      subject(:bishop) { described_class.new(-3) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(bishop, 4, 7)
      end
      it 'returns correct number of moves' do
        board = chess_board.board_array
        expect(bishop.valid_moves(board)).to contain_exactly(
          [5, 6], [6, 5], [7, 4],
          [3, 6], [2, 5], [1, 4], [0, 3]
        )
      end
    end
  end

  describe '#move_to' do
    context 'when bishop is at (7, 7)' do
      subject(:bishop) { described_class.new(-3) }
      let(:enemy_rook) { described_class.new(4) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(bishop, 7, 0)
        chess_board.add_piece(enemy_rook, 0, 7)
      end
      it 'should place the bishop at (0, 7) and capture the enemy piece' do
        board = chess_board.board_array
        bishop.move_to(0, 7, board)
        expect(chess_board.piece_at(0, 7)).to eq(bishop)
        expect(enemy_rook.captured).to be true
      end
    end
  end

  describe '#capture_at' do
    context 'when bishop is at (6, 3) and enemy is at (4, 1)' do
      subject(:bishop) { described_class.new(-3) }
      let(:enemy) { described_class.new(1) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(bishop, 6, 3)
        chess_board.add_piece(enemy, 4, 1)
      end
      it 'catpures the enemy piece' do
        board = chess_board.board_array
        bishop.capture_at(4, 1, board)
        expect(chess_board.piece_at(4, 1)).to eq(bishop)
        expect(enemy.captured).to be true
      end
    end
  end
end
