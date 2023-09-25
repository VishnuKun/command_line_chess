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
        chess_board.add_piece(pawn, 'a2')
      end
      it "moves the piece from one box to another" do
        destination = 'a4'
        chess_board.move_piece(pawn, destination)
        expect(chess_board.piece_at('a4')).to eq(pawn)
      end
    end
    
    context "when given invalid position" do
      before do 
        chess_board.add_piece(pawn, 'a2')
      end
      it "does nothing" do
        destination = 'a8'
        expect(chess_board.move_piece(pawn, destination)).to raise_error
      end
    end
  end

  describe "#remove_piece" do
    subject(:chess_board) { described_class.new }
    subject(:rook) { Piece.new(-6)}

    context "when given position" do
      before do 
        chess_board.add_piece(rook, 'a1')
      end
      it "removes the piece on that position" do 
        target_position = 'a1'
        chess_board.remove_piece(target_position)
        expect(chess_board.piece_at(target_position)).to be_nil
      end
    end
  end
end