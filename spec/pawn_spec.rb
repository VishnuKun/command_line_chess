# frozen_string_literal: true

# spec/pieces_spec.rb

require 'spec_helper'
require 'pieces'
require 'chessboard'

describe Pawn do
  describe '#valid_moves' do
    context 'when pawn is at (1, 0) on an empty chessboard' do
      subject(:piece) { described_class.new(-1) }
      subject(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(piece, 1, 0)
      end
      it 'returns 2 possible moves' do
        expect(piece.valid_moves).to contain_exactly([2, 0], [3, 0])
      end
    end

    context 'when pawn has already moved' do
      subject(:pawn) { described_class.new(-1) }
      subject(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(pawn, 2, 0)
        pawn.moved = true
      end
      it 'returns only one move' do
        expect(pawn.valid_moves).to contain_exactly([2, 0])
      end
    end
  end

  describe '#move_to' do
    context 'when pawn is at (0, 0) and given specific position to reach' do
      subject(:piece) { described_class.new(-1) }
      subject(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(piece, 0, 0)
      end
      it 'moves the piece to the given position' do
        piece.move_to(3, 3)
        expect(piece.position).to eq([3, 3])
      end
    end
  end

  describe '#capture_at' do
    context 'when enemy king is at (0, 3)' do
      subject(:king) { King.new(-5) }
      subject(:chess_board) { Chessboard.new }
      subject(:pawn) { described_class.new(1) }
      before do
        chess_board.add_piece(king, 0, 3)
        chess_board.add_piece(pawn, 1, 4)
      end
      it 'removes king and positions itself' do
        pawn.capture_at(0, 3)
        expect(chess_board.piece_at(0, 3)).to eq(pawn)
      end
    end
  end

  describe '#en_passant' do
    context 'when black pawn does a double step' do
      subject(:black_pawn) { described_class.new(-1) }
      subject(:white_pawn) { described_class.new(1) }
      subject(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(black_pawn, 3, 0)
        chess_board.add_piece(white_pawn, 3, 1)
        allow(chess_board).to receive(:en_passant_possible?).and_return(true)
      end
      it 'removes the black pawn and moves the white pawn' do
        white_pawn.en_passant(2, 0)
        expect(chess_board.piece_at(2, 0)).to eq white_pawn
        expect(chess_board.piece_at(3, 0)).to be_nil
      end
    end

    context 'when unavailable' do
      subject(:black_pawn) { described_class.new(-1) }
      subject(:white_pawn) { described_class.new(1) }
      subject(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(white_pawn, 3, 0)
        chess_board.add_piece(black_pawn, 3, 1)
        allow(chess_board).to receive(:en_passant_possible?).and_return(false)
      end
      it "doesn't remove and move any piece on the board" do
        black_pawn.en_passant(2, 0)
        expect(chess_board.piece_at(2, 0)).not_to eq black_pawn
        expect(chess_board.piece_at(3, 0)).to eq(white_pawn)
      end
    end
  end

  describe '#promote_to' do
    context 'when pawn reaches the top' do
      subject(:pawn) { described_class.new(1) }
      subject(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(pawn, 0, 0)
        allow(chess_board).to receive(:promotion_possible?).and_return(true)
      end
      it 'should promote pawn to desired piece' do
        pawn.promote_to(Queen)
        expect(chess_board.piece_at(0, 0)).to be_an_instance_of(Queen)
      end
    end
  end
end
