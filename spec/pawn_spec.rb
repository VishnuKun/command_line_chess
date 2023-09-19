# frozen_string_literal: true

# spec/pieces_spec.rb

require 'spec_helper'
require 'pieces'

describe Pawn do

  describe "#legal_moves" do
    subject(:pawn_moves) { described_class.new }

    context "when pawn is at starting position" do
      it "returns single and double step moves" do
        expect(pawn_moves.legal_moves('a7')).to contain_exactly('a6', 'a5')
      end
    end

    context "when pawn blockage occurs" do
      before do 
        allow(pawn_moves).to receive(:pawn_blocked?).and_return(true)
      end
      it "returns 0" do
        expect(pawn_moves.legal_moves('a4')).to contain_exactly(0)
      end
    end
  end

  describe "#capture" do 
    subject(:pawn_captures) { described_class.new }
    board = double("Board")
    context "when capturing an opponent's piece" do
      before do 
        enemy_pawn = described_class.new('d5')
        allow(board).to receive(:remove_piece)
        allow(board).to receive(:get_piece).with('d5').and_return(enemy_pawn)
      end
      it "removes the captured piece from the board" do 
        pawn_captures.capture('d5', board)
        expect(board).to have_received(:remove_piece).with('d5')
      end
    end
  end

  describe "#move" do 
    subject(:pawn_moves) { described_class.new('a7') }
    context "when invoked with 'c6' to 'c5'" do 
      it "should move the pawn to 'c5' spot" do 
        pawn_moves.move('c5')
        expect(pawn_moves.locate).to eq('c5')
      end
    end

    context "in case of pawn's initial double-step" do 
      before do 
        allow(pawn_moves).to receive(:double_step_possible?).and_return(true)
      end
      it "should move the pawn from 'a7' to 'a5'" do
        pawn_moves.move('a5')
        expect(pawn_moves.locate).to eq('a5')
      end
    end

    context "when invalid move is given" do 
      it "should raise an error" do
        error_message = "Invalid move. Please try again."
        expect { pawn_moves.move('g0') }.to raise_error(error_message)
      end
    end
  end

  describe "#en_passant" do 
    subject(:pawn_en_passant) { described_class.new }
    
    context "when en-passant is possible" do
      before do 
        allow(pawn_en_passant).to receive(:en_passant_possible?).and_return(true)
      end
      it "should capture and place the pawn correctly" do
        pawn_en_passant.en_passant('b3')
        expect(pawn_en_passant.locate).to eq('b3')
      end
    end
  end

  describe "#promote" do 
    subject(:pawn_promoted) { described_class.new }
    context "when promoting to queen" do 
      it "should promote the pawn to queen" do
        pawn_promoted.promote('queen')
        expect(pawn_promoted).to be_an_instance_of(Queen)
      end
    end
  end
end