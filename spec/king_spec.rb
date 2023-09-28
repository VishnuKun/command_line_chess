# frozen_string_literal: true

# spec/king_spec.rb

require 'spec_helper'
require 'pieces'
require 'chessboard'

describe King do
  describe '#valid_moves' do
    context 'when invoked with given position and piece' do
      before do
        subject(:black_king) { described_class.new(-5) }
        subject(:chess_board) { Chessboard.new }
        chess_board.add_piece(black_king, 0, 3)
      end
      it 'returns correct number of moves' do
        expect(black_king.valid_moves).to contain_exactly([0, 2], [0, 4], [1, 2], [1, 4], [1, 4])
      end
    end

    context 'when piece has moved' do
      before do
        subject(:black_king) { described_class.new(-5) }
        subject(:chess_board) { Chessboard.new }
        chess_board.add_piece(black_king, 3, 4)
      end
      it 'returns correct number of moves' do
        expect(black_king.valid_moves).to contain_exactly([2, 3], [2, 4], [2, 5], [3, 3], [3, 5], [4, 3], [4, 4],
                                                          [4, 5])
      end
    end
  end

  describe '#move_to' do
    context 'when given a move' do
      before do
        subject(:king) { described_class.new(6) }
        subject(:chess_board) { Chessboard.new }
        chess_board.add_piece(king, 0, 4)
      end
      it 'moves the piece to the correct position' do
        king.move_to(1, 5)
        expect(king.position).to eq([1, 5])
      end
    end
  end

  describe 'capture_at' do
    context 'when given position' do
      before do
        subject(:king) { described_class.new(-5) }
        subject(:chess_board) { Chessboard.new }
        subject(:pawn) { Pawn.new(1) }
        chess_board.add_piece(king, 1, 4)
        chess_board.add_piece(pawn, 2, 5)
      end
      it 'removes the piece at specified position' do
        king.capture_at(2, 5)
        expect(chess_board.piece_at(2, 5)).to be_nil
      end
    end
  end
  
  describe '#castle' do
    context 'when available' do
      before do
        subject(:chess_board) { Chessboard.new }
        subject(:white_king) { described_class.new(6) }
        subject(:left_rook) { Rook.new(4) }
        subject(:right_rook) { Rook.new(4) }
        chess_board.add_piece(white_king, 7, 4)
        chess_board.add_piece(left_rook, 7, 0)
        chess_board.add_piece(right_rook, 7, 7)
        allow(chess_board).to receive(:castle_possible?).and_return(true)
      end
      it 'exchanges the position of the left rook and king' do
        white_king.castle(left_rook)
        expect(white_king.position).to eq([7, 2])
        expect(left_rook.position).to eq([7, 3])
        expect(right_rook.position).to eq([7, 7])
      end
    end
    
    context 'when a piece is inbetween' do
      before do
        subject(:chess_board) { Chessboard.new }
        subject(:white_king) { described_class.new(6) }
        subject(:left_rook) { Rook.new(4) }
        subject(:right_rook) { Rook.new(4) }
        subject(:knight) { Knight.new(2) }
        chess_board.add_piece(white_king, 7, 4)
        chess_board.add_piece(left_rook, 7, 0)
        chess_board.add_piece(right_rook, 7, 7)
        chess_board.add_piece(knight, 7, 1)
        allow(chess_board).to receive(:castle_possible?).and_return(false)
      end
      it "doesn't change the positions of the rook and king" do
        white_king.castle(left_rook)
        expect(white_king.position).to eq([7, 4])
        expect(left_rook.position).to eq([7, 0])
        expect(right_rook.position).to eq([7, 7])
      end
    end
  end
end
