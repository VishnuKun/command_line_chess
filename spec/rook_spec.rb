# frozen_string_literal: true

# spec/queen_spec.rb

require 'spec_helper'
require 'pieces'
require 'chessboard'

describe Rook do 
    describe "#valid_moves" do 
        context "when rook is located the bottom left corner of the board (7, 0)" do
            subject(:rook) { described_class.new(4) }
            subject(:chess_board) { Chessboard.new }
            before do 
                chess_board.add_piece(rook, 7, 0)
            end
            it 'returns the correct number of moves' do 
                expect(rook.valid_moves).to contain_exactly(
                    [0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], 
                    [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7]
                )
            end
        end
        
        context "when rook is at (3, 3) position with an enemy piece at (3, 7)" do 
            subject(:rook) { described_class.new(4) }
            subject(:pawn) { Pawn.new(-1) }
            subject(:chess_board) { Chessboard.new }
            before do 
                chess_board.add_piece(rook, 3, 3)
                chess_board.add_piece(pawn, 3, 7)
            end
            it "returns the correct number of moves" do 
                expect(rook.valid_moves).to contain_exactly(
                    [0, 3], [1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3],
                    [3, 0], [3, 1], [3, 2], [3, 4], [3, 5], [3, 6], [3, 7]
                )
            end
        end
    end
end