# frozen_string_literal: true

# spec/queen_spec.rb

require 'spec_helper'
require 'game'

describe Game do
  describe '#game_over?' do
    let(:game) { described_class.new }

    context 'when the game is ongoing' do
      before do
        allow(game).to receive(:draw).and_return(false)
        allow(game).to receive(:win?).and_return(false)
        allow(game).to receive(:lose?).and_return(false)
      end
      it 'returns false' do
        expect(game.game_over?).to eq(false)
      end
    end

    context 'when enemy checkmates your king' do
      before do
        allow(game).to receive(:lose?).and_return(true)
      end
      it 'returns true' do
        expect(game.game_over?).to eq(true)
      end
    end

    context 'when you checkmates your enemies king' do
      before do
        allow(game).to receive(:win?).and_return(true)
      end
      it 'returns true' do
        expect(game.game_over?).to eq(true)
      end
    end

    context 'when a stalemate occurs' do
      before do
        allow(game).to receive(:draw?).and_return(true)
      end
      it 'returns true' do
        expect(game.game_over?).to eq(true)
      end
    end

    context '50 move rule' do
      before do
        allow(game).to receive(:draw?).and_return(true)
      end
      it 'returns true' do
        expect(game.game_over?).to eq(true)
      end
    end

    context 'in case of repition' do
      before do
        allow(game).to receive(:draw?).and_return(true)
      end
      it 'returns true' do
        expect(game.game_over?).to eq(true)
      end
    end

    context 'insufficient material' do
      before do
        allow(game).to receive(:draw?).and_return(true)
      end
      it 'returns true' do
        expect(game.game_over?).to eq(true)
      end
    end
  end
end
