# frozen_string_literal: true

# spec/spot_spec.rb

require 'spot'
require 'pieces'
require 'spec_helper'

describe Spot do
  describe '#empty?' do
    context 'when invoked on an empty spot' do
      subject(:empty_spot) { described_class.new }
      it 'returns true' do
        expect(empty_spot.empty?).to eq(true)
      end
    end

    context 'when invoked on an filled spot' do
      subject(:spot) { described_class.new }
      let(:piece) { Piece.new(-1) }
      before do
        spot.piece = piece
      end
      it 'returns true' do
        expect(spot.empty?).to eq(false)
      end
    end
  end
end
