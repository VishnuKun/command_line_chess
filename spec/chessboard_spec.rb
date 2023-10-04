# frozen_string_literal: true

# spec/chessboard_spec.rb

require 'chessboard'
require 'pieces'
require 'spec_helper'

describe Chessboard do

  describe "#move_piece" do 
    subject(:chess_board) { described_class.new }
    let(:pawn) { Piece.create_piece(-1) }
    
    context "when pawn is at (1, 0) on an empty board" do
      before do 
        chess_board.add_piece(pawn,1, 0)
      end
      it "moves pawn from (1, 0) to (3, 0)" do
        destination = [3, 0]
        chess_board.move_piece(pawn, destination)
        expect(chess_board.piece_at(3, 0)).to eq(pawn)
      end
    end
    
    context "when given invalid position" do
      before do 
        chess_board.add_piece(pawn, 1, 0)
      end
      it "raises an error" do
        destination = [7, 0]
        expect(chess_board.move_piece(pawn, destination)).to raise_error
      end
    end
  end

  describe "#remove_piece" do
    subject(:chess_board) { described_class.new }
    let(:rook) { Piece.create_piece(-6)}

    context "when rook is at (0, 0)" do
      before do 
        chess_board.add_piece(rook, 0, 0)
      end
      it "removes rook from (0, 0)" do 
        chess_board.remove_piece(0, 0)
        expect(chess_board.piece_at(0, 0)).to be_nil
      end
    end
  end
end