# frozen_string_literal: true

# spec/pieces_spec.rb

require 'spec_helper'
require 'pieces'
require 'chessboard'

describe Pawn do
  describe '#valid_moves' do
    context 'when invoked with given position and piece' do
      before do
        subject(:piece) { described_class.new(-1) }
        subject(:chess_board) { Chessboard.new }
        chess_board.add_piece(piece, 1, 0)
      end
      it 'returns correct possible moves' do
        expect(piece.valid_moves).to contain_exactly([2, 0], [3, 0])
      end
    end

    context 'when piece has moved already' do
      before do
        subject(:pawn) { described_class.new(-1) }
        subject(:chess_board) { Chessboard.new }
        chess_board.add_piece(pawn, 2, 0)
        pawn.moved = true
      end
      it 'return only one move' do
        expect(pawn.valid_moves).to contain_exactly([2, 0])
      end
    end
  end

  describe '#move_to' do
    context 'when given a move' do
      before do 
        subject(:piece) { described_class.new(-1) }
        subject(:chess_board) { Chessboard.new }
        chess_board.add_piece(piece, 0, 0)
      end
      it 'moves the piece to the given position' do
        piece.move_to(3, 3)
        expect(piece.position).to eq([3, 3])
      end
    end
  end

  describe '#capture_at' do
    context 'when given position' do
      before do
        subject(:king) { King.new(-5) }
        subject(:chess_board) { Chessboard.new }
        subject(:pawn) { described_class.new(1) }
        chess_board.add_piece(king, 0, 3)
        chess_board.add_piece(pawn, 1, 4)
      end
      it 'removes the piece at specified position' do
        pawn.capture_at(0, 3)
        expect(chess_board.piece_at(0, 3)).to be_nil
      end
    end
  end

  describe "#en_passant" do
    context "when available" do
      before do 
        subject(:attacking_pawn) { described_class.new(1)}
        subject(:target_pawn) { described_class.new(1)}
        subject(:chess_board) { Chessboard.new }
        chess_board.add_piece(target_pawn, 3, 0)
        chess_board.add_piece(attacking_pawn, 3, 1)
        target_pawn.moved = true
      end
      it "removes the black pawn and moves the white pawn" do 
        attacking_pawn.en_passant(2, 0)
        expect(chess_board.piece_at(2, 0)).to eq attacking_pawn
        expect(chess_board.piece_at(3, 0)).to be_nil
      end
    end
    
    context "when unavailable" do
      before do 
        subject(:attacking_pawn) { described_class.new(1)}
        subject(:target_pawn) { described_class.new(1)}
        subject(:chess_board) { Chessboard.new }
        chess_board.add_piece(target_pawn, 3, 0)
        chess_board.add_piece(attacking_pawn, 3, 1)
        target_pawn.moved = false
      end
      it "doesn't remove and move any piece on the board" do 
        attacking_pawn.en_passant(2, 0)
        expect(chess_board.piece_at(2, 0)).not_to eq attacking_pawn
        expect(chess_board.piece_at(3, 0)).to eq(target_pawn)
      end
    end

  end

  describe "#promote_to" do
    context "when pawn reaches the top" do
      before do 
        subject(:target_pawn) { described_class.new(1)}
        subject(:chess_board) { Chessboard.new }
        chess_board.add_piece(target_pawn, 0, 0)
      end
      it "should promote pawn to desired piece" do
        target_pawn.promote_to(Queen)
        expect(chess_board.piece_at(0, 0)).to be_an_instance_of(Queen)
      end
    end
  end
end
