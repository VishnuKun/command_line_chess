# frozen_string_literal: true

# spec/chessboard_spec.rb

require_relative '../lib/pieces'
require_relative '../lib/pawn'
require_relative '../lib/chessboard'
require_relative 'spec_helper'

describe Chessboard do

  describe "#move_piece" do 
    subject(:chess_board) { described_class.new }
    let(:pawn) { Piece.create_piece(-1) }
    
    context "when pawn is at (1, 0) on an empty board" do
      before do 
        chess_board.add_piece(pawn,1, 0)
      end
      it "moves pawn from (1, 0) to (3, 0)" do
        chess_board.move_piece(pawn, 3, 0)
        expect(chess_board.piece_at(3, 0)).to eq(pawn)
      end
    end
  end

  describe "#remove_piece" do
    subject(:chess_board) { described_class.new }
    let(:rook) { Piece.create_piece(-4)}

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