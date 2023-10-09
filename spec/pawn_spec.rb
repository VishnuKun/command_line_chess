# frozen_string_literal: true

# spec/pieces_spec.rb

require_relative '../lib/pawn'
require_relative '../lib/pieces'
require_relative '../lib/chessboard'
require_relative 'spec_helper'

describe Pawn do
  describe '#valid_moves' do
    # for black pawn
    context 'when black pawn is at position (7, 0) on empty board' do
      subject(:black_pawn) { described_class.create_piece(-1) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(black_pawn, 7, 0)
      end
      it 'returns 2 possible moves' do
        board = chess_board.board_array
        expect(black_pawn.valid_moves(board)).to contain_exactly([6, 0], [5, 0])
      end
    end

    context 'when black pawn has already moved one step' do
      subject(:black_pawn) { described_class.create_piece(-1) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(black_pawn, 6, 0)
        black_pawn.moved = true
      end
      it 'returns only one move' do
        board = chess_board.board_array
        expect(black_pawn.valid_moves(board)).to contain_exactly([5, 0])
      end
    end

    context 'when black black_pawn has reached the top i.e. row 0' do
      subject(:black_pawn) { described_class.create_piece(-1) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(black_pawn, 0, 0)
        black_pawn.moved = true
      end
      it 'returns empty array and can be promoted' do
        board = chess_board.board_array
        expect(black_pawn.valid_moves(board)).to contain_exactly
        expect(black_pawn.can_be_promoted).to be true
      end
    end
    # for white pawn
    context 'when white pawn is at the position (0, 0) on empty board' do
      subject(:white_pawn) { described_class.create_piece(1) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(white_pawn, 0, 0)
      end
      it 'returns 2 possible moves' do
        board = chess_board.board_array
        expect(white_pawn.valid_moves(board)).to contain_exactly([1, 0], [2, 0])
      end
    end

    context 'when white pawn has already moved one step' do
      subject(:white_pawn) { described_class.create_piece(1) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(white_pawn, 1, 0)
        white_pawn.moved = true
      end
      it 'returns only one move' do
        board = chess_board.board_array
        expect(white_pawn.valid_moves(board)).to contain_exactly([2, 0])
      end
    end

    context 'when white pawn has reached the top i.e. row 7' do
      subject(:white_pawn) { described_class.create_piece(1) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(white_pawn, 7, 0)
        white_pawn.moved = true
      end
      it 'returns empty array and can be promoted' do
        board = chess_board.board_array
        expect(white_pawn.valid_moves(board)).to contain_exactly
        expect(white_pawn.can_be_promoted).to eql(true)
      end
    end
  end

  describe '#move_to' do
    context 'when black pawn is at (0, 0) and given specific position to reach' do
      subject(:piece) { described_class.create_piece(-1) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(piece, 0, 0)
      end
      it 'moves the piece to the given position' do
        board = chess_board.board_array
        piece.move_to(3, 3, board)
        expect(chess_board.piece_at(3, 3)).to eq(piece)
        expect(chess_board.piece_at(0, 0)).to be nil
      end
    end
  end

  describe '#capture_at' do
    context 'when enemy king is at (0, 3)' do
      subject(:pawn) { described_class.create_piece(1) }
      let(:king) { Piece.create_piece(-5) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(king, 0, 3)
        chess_board.add_piece(pawn, 1, 4)
      end
      it 'removes king and positions itself' do
        board = chess_board.board_array
        pawn.capture_at(0, 3, board)
        expect(chess_board.piece_at(0, 3)).to eq(pawn)
      end
    end
  end

  describe '#en_passant' do
    context 'when black pawn does a double step' do
      subject(:black_pawn) { described_class.create_piece(-1) }
      let(:white_pawn) { described_class.create_piece(1) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(white_pawn, 1, 1)
        chess_board.add_piece(black_pawn, 4, 1)
      end
      it 'captures the black pawn and places the white on the spot' do
        board = chess_board.board_array
        white_pawn.move_to(3, 1, board)
        black_pawn.en_passant(3, 2, board)
        expect(chess_board.piece_at(3, 2)).to be(black_pawn)
        expect(chess_board.piece_at(4, 1)).to be_nil
      end
    end
    

    context 'when white pawn does a double step' do
      subject(:black_pawn) { described_class.create_piece(-1) }
      let(:white_pawn) { described_class.create_piece(1) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(white_pawn, 1, 1)
        chess_board.add_piece(black_pawn, 4, 1)
      end
      it 'captures white pawn and places black on the spot' do
        board = chess_board.board_array
        white_pawn.move_to(3, 1, board)
        black_pawn.en_passant(3, 2, board)
        expect(chess_board.piece_at(3, 2)).to be(black_pawn)
        expect(chess_board.piece_at(3, 1)).to be_nil
      end
    end
  end

  describe '#promote_to' do
    context 'when white pawn reaches the farthest point i.e. row 7' do
      subject(:pawn) { described_class.create_piece(1) }
      let(:chess_board) { Chessboard.new }
      before do
        chess_board.add_piece(pawn, 7, 0)
      end
      it 'should promote pawn to desired piece' do
        board = chess_board.board_array
        pawn.promote_to(-6, board)
        expect(chess_board.piece_at(7, 0)).to be_an_instance_of(Queen)
        expect(chess_board.piece_at(7, 0).color).to eq('white')
      end
    end
  end
end
