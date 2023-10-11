# frozen_string_literal: true

# spec/king_spec.rb

require 'spec_helper'
require 'pieces'
require 'chessboard'

describe King do
  describe '#valid_moves' do
    context 'when king is at (0, 3) on empty chess board' do
      subject(:black_king) { King.new(-5) }
      let(:chess_board) { Chessboard.new }

      before do
        chess_board.add_piece(black_king, 0, 3)
      end
      it 'returns correct number of moves' do
        expect(black_king.valid_moves(chess_board.board_array)).to contain_exactly([0, 2], [0, 4], [1, 2], [1, 3],
                                                                                   [1, 4])
      end
    end

    context 'when king is at (3, 4) on empty board' do
      subject(:black_king) { King.new(-5) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(black_king, 3, 4)
      end
      it 'returns correct number of moves' do
        expect(black_king.valid_moves(chess_board.board_array)).to contain_exactly([2, 3], [2, 4], [2, 5], [3, 3], [3, 5], [4, 3], [4, 4],
                                                                                   [4, 5])
      end
    end

    context 'when king is at (7, 0) and enemy rook is in column 6' do
      subject(:white_king) { King.new(6) }
      let(:enemy_rook) { Rook.new(-4) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(white_king, 0, 7)
        chess_board.add_piece(enemy_rook, 7, 6)
      end
      it 'returns only those moves which wont get king killed' do
        expect(white_king.valid_moves(chess_board.board_array)).to contain_exactly(
          [1, 7]
        )
      end
    end
  end

  describe '#move_to' do
    context 'when king is at (0, 4) on empty chess board' do
      subject(:king) { King.new(6) }
      let(:chess_board) { Chessboard.new }

      before do
        chess_board.add_piece(king, 0, 4)
      end
      it 'moves the piece to the correct position' do
        king.move_to(1, 5, chess_board.board_array)
        expect(chess_board.piece_at(1, 5)).to eq(king)
      end
    end
  end

  describe 'capture_at' do
    context 'when king is at position (1, 4) on the chess board with pawn at (2, 5)' do
      subject(:king) { King.new(-5) }
      let(:chess_board) { Chessboard.new }
      let(:pawn) { Pawn.new(1) }

      before do
        chess_board.add_piece(king, 1, 4)
        chess_board.add_piece(pawn, 2, 5)
      end
      it 'removes the piece at specified position' do
        king.capture_at(2, 5, chess_board.board_array)
        expect(chess_board.piece_at(2, 5)).to eq(king)
      end
    end
  end

  describe '#castle_left' do
    context 'when path is clear at row 7' do
      subject(:white_king) { King.new(6) }
      let(:chess_board) { Chessboard.new }
      let(:left_rook) { Rook.new(4) }
      let(:right_rook) { Rook.new(4) }

      before do
        chess_board.add_piece(white_king, 7, 4)
        chess_board.add_piece(left_rook, 7, 0)
        chess_board.add_piece(right_rook, 7, 7)
      end
      it 'exchanges the position of the left rook and king' do
        white_king.castle_left(chess_board.board_array)

        expect(chess_board.piece_at(7, 7)).to eq(right_rook)
        expect(chess_board.piece_at(7, 2)).to eq(white_king)
        expect(chess_board.piece_at(7, 3)).to eq(left_rook)
      end
    end

    context 'when piece is at (7, 1)' do
      subject(:white_king) { King.new(6) }
      let(:chess_board) { Chessboard.new }
      let(:left_rook) { Rook.new(4) }
      let(:right_rook) { Rook.new(4) }
      let(:knight) { Knight.new(2) }

      before do
        chess_board.add_piece(white_king, 7, 4)
        chess_board.add_piece(left_rook, 7, 0)
        chess_board.add_piece(right_rook, 7, 7)
        chess_board.add_piece(knight, 7, 1)

      end
      it "doesn't change the positions of the rook and king" do
        white_king.castle_left(chess_board.board_array)

        expect(chess_board.piece_at(7, 4)).to eq(white_king)
        expect(chess_board.piece_at(7, 0)).to eq(left_rook)
        expect(chess_board.piece_at(7, 7)).to eq(right_rook)
        expect(chess_board.piece_at(7, 1)).to eq(knight)
      end
    end
  end
end
