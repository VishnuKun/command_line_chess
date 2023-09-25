# frozen_string_literal: true

# spec/spot_spec.rb

require 'spot'
require 'pieces'
require 'spec_helper'

describe Spot do
  describe '#is_empty?' do
    context 'when invoked on an empty spot' do
      subject(:empty_spot) { described_class.new }
      it 'returns true' do
        expect(empty_spot.is_empty?).to eq(true)
      end
    end

    context 'when invoked on an filled spot' do
      before do
        subject(:piece) { Piece.new(-1) }
        subject(:filled_spot) { described_class.new(piece) }
      end
      it 'returns true' do
        expect(filled_spot.is_empty?).to eq(false)
      end
    end
  end

  describe '#remove_piece' do
    context 'when invoked on spot with a piece' do
      subject(:piece) { Piece.new(1) }
      subject(:spot_remove) { described_class.new(piece) }
      before do
        spot_remove.remove_piece
      end
      it 'removes the piece from the spot' do
        expect(spot.empty).to eq(true)
      end
    end
  end
end
