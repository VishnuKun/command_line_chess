# frozen_string_literal: true

# spec/chessboard_spec.rb

require 'chessboard'
require 'pieces'
require 'spec_helper'

describe Chessboard do

  describe "#move_piece" do 
    subject(:chess_board) { described_class.new }
    subject(:pawn) { Piece.new(-1) }
    
    context "when given position and piece" do
      before do 
        chess_board.add_piece(pawn,1, 0)
      end
      it "moves the piece from one box to another" do
        destination = [3, 0]
        chess_board.move_piece(pawn, destination)
        expect(chess_board.piece_at(3, 0)).to eq(pawn)
      end
    end
    
    context "when given invalid position" do
      before do 
        chess_board.add_piece(pawn, 1, 0)
      end
      it "does nothing" do
        destination = [7, 0]
        expect(chess_board.move_piece(pawn, destination)).to raise_error
      end
    end
  end

  describe "#remove_piece" do
    subject(:chess_board) { described_class.new }
    subject(:rook) { Piece.new(-6)}

    context "when given position" do
      before do 
        chess_board.add_piece(rook, 0, 0)
      end
      it "removes the piece on that position" do 
        chess_board.remove_piece(0, 0)
        expect(chess_board.piece_at(0, 0)).to be_nil
      end
    end
  end
end