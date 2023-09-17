# frozen_string_literal: true

# spec/pieces_spec.rb

require 'pieces'
require 'spec_helper'

describe Pawn do
  subject(:pawn) { described_class.new(:white) }

  before do 
    allow(pawn).to receive(:valid_move?).and_return(true)
    allow(pawn).to receive(:in_bounds?).and_return(true)
  end

  describe '#possible_moves?' do
    context "when pawn is at starting position i.e. 'a7'" do
      before do 
        allow(pawn).to receive(:occupied?).and_return(false)
        allow(pawn).to receive(:capture_move?).and_return(false)
        allow(pawn).to receive(:en_passant?).and_return(false)
      end
      it 'returns correct possible moves' do
        result = pawn.possible_moves?('a7')
        expect(result).to contain_exactly(['a5', 'a6'])
      end
    end
    
    context "when pawn has already moved" do
      before do
        allow(pawn).to receive(:occupied?).and_return(false)
        allow(pawn).to receive(:capture_move?).and_return(false)
        allow(pawn).to receive(:en_passant?).and_return(false)
      end
      it "returns correct possible moves" do
        result = pawn.possible_moves?('a6')
        expect(result).to contain_exactly(['a5'])
      end
    end
    
    context "when pawn is face to face with other pawns" do
      before do
        allow(pawn).to receive(:occupied?).and_return(true)
        allow(pawn).to receive(:capture_move?).and_return(false)
        allow(pawn).to receive(:en_passant?).and_return(false)
      end
      it "returns 0" do 
        result = pawn.possible_moves?('b4')
        expect(result).to eq(0)
      end
    end
    
    context "when pawn can capture opponent's pawn" do 
      before do
        allow(pawn).to receive(:occupied?).and_return(true)
        allow(pawn).to receive(:capture_move?).and_return(true)
        allow(pawn).to receive(:en_passant?).and_return(true)
      end
      it "returns correct possible moves" do 
        result = pawn.possible_moves?('d4')
        expect(result).to contain_exactly(['c3', 'e3'])
      end
    end
  end
end