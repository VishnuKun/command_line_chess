# frozen_string_literal: true

# spec/chessboard_spec.rb

require 'chessboard'
require 'spec_helper'

describe Chessboard do
  describe '#print_board' do
    subject(:game_board) { described_class.new }
    context 'when invoked' do
      it 'prints the board' do
        result = game_board.print_board
        solution = <<-BOARD
                       ⒜   ⒝   ⒞   ⒟   ⒠   ⒡   ⒢   ⒣
                 ⑴  | ♖ | ♘ | ♗ | ♕ | ♔ | ♗ | ♘ | ♖ |  ⑴
                  ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
                 ⑵  | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ |  ⑵
                 ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
                 ⑶ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ⑶
                 ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
                 ⑷ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ⑷
                 ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
                 ⑸ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ⑸
                 ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
                 ⑹ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ⑹
                 ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
                 ⑺  | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ |  ⑺
                  ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
                 ⑻  | ♜ | ♞ | ♝ | ♚ | ♛ | ♝ | ♞ | ♜ |  ⑻
                       ⒜   ⒝   ⒞   ⒟   ⒠   ⒡   ⒢   ⒣
        BOARD
        expect(result).to eq(solution)
      end
    end
  end

  describe '#place_piece' do
    subject(:game_place) { described_class.new }
    context 'when given piece and position' do
      before do
        board = game_place.instance_variable_get(:@board)
        allow(game_place).to receive(:coordinate?).with('a5').and_return(board[4][0])
      end
      it 'should place the piece on the board' do
        game_place.place_piece('♜', 'a5')
        expect(game_place.instance_variable_get(:@board)[4][0]).to eq('♜')
      end
    end

    context 'when piece is removed from original position' do
      before do
        game_place.place_piece('♜', 'a5')
      end
      it 'should replace original position with appropriate square' do
        expect(game_place.instance_variable_get(:@board)[7][0]).to eq('██')
      end
    end
  end
end
