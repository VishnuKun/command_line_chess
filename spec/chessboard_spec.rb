# frozen_string_literal: true

# spec/chessboard_spec.rb

require 'chessboard'
require 'spec_helper'

describe Chessboard do
  describe '#print_board' do
    subject(game_board) { described_class.new }
    context 'when invoked' do
      it 'prints the board' do
        result = game_board.print_board
        solution = <<-Board
                       ⒜   ⒝   ⒞   ⒟   ⒠   ⒡   ⒢   ⒣
                  ⑴ | ♖ | ♘ | ♗ | ♕ | ♔ | ♗ | ♘ | ♖ | ⑴
                  ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
                  ⑵ | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ | ⑵
                 ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
              ⑶ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ⑶
              ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
              ⑷ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ⑷
              ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
              ⑸ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ⑸
              ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
              ⑹ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ░░ | ██ | ⑹
                 ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
                  ⑺ | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ | ⑺
                  ⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋⚋
                  ⑻ | ♜ | ♞ | ♝ | ♚ | ♛ | ♝ | ♞ | ♜ | ⑻
                       ⒜   ⒝   ⒞   ⒟   ⒠   ⒡   ⒢   ⒣
        Board
        expect(result).to eq(solution)
      end
    end
  end
end
