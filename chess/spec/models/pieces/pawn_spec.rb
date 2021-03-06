require "set"

require "models/pieces/pawn.rb"
require "models/chess_board.rb"

describe Pawn do

  let(:board) { ChessBoard.new }

  def get_moves
    Set.new(subject.get_moves)
  end

  context 'black pawn' do
    subject { Pawn.new(board, :black) }

    context 'when placed at (6, 1)' do
      before { board.set_piece(6, 1, subject) }
      it 'can move one or two spaces forward' do
        expect(get_moves).to eql(Set.new([{ row: 5, col: 1 }, { row: 4, col: 1 }]))
      end

      context 'with different color piece on (5, 2)' do
        before { board.set_piece(5, 2, Knight.new(board, :white)) }
        it 'can attack it' do
          expect(get_moves).to include({ row: 5, col: 2 })
        end
      end

      context 'with different color piece on (5, 0)' do
        before { board.set_piece(5, 0, Knight.new(board, :white)) }
        it 'can attack it' do
          expect(get_moves).to include({ row: 5, col: 0 })
        end
      end

      context 'with different color piece on (5, 1)' do
        before { board.set_piece(5, 1, Knight.new(board, :white)) }
        it 'cannot move to (2, 1)' do
          expect(get_moves).not_to include({ row: 5, col: 1 })
        end
      end

      context 'with same color piece on (4, 1)' do
        before { board.set_piece(4, 1, Knight.new(board, :black)) }
        it 'cannot move to (3, 1)' do
          expect(get_moves).not_to include({ row: 4, col: 1 })
        end
      end
    end

    context 'when placed at (5, 1)' do
      before { board.set_piece(5, 1, subject) }
      it 'can move one space forward' do
        expect(get_moves).to eql(Set.new([{ row: 4, col: 1 }]))
      end
    end
  end

  context 'white pawn' do
    subject { Pawn.new(board, :white) }

    context 'when placed at (1, 1)' do
      before { board.set_piece(1, 1, subject) }
      it 'can move one or two spaces forward' do
        expect(get_moves).to eql(Set.new([{ row: 2, col: 1 }, { row: 3, col: 1 }]))
      end

      context 'with different color piece on (2, 2)' do
        before { board.set_piece(2, 2, Knight.new(board, :black)) }
        it 'can attack it' do
          expect(get_moves).to include({ row: 2, col: 2 })
        end
      end

      context 'with different color piece on (2, 0)' do
        before { board.set_piece(2, 0, Knight.new(board, :black)) }
        it 'can attack it' do
          expect(get_moves).to include({ row: 2, col: 0 })
        end
      end

      context 'with different color piece on (2, 1)' do
        before { board.set_piece(2, 1, Knight.new(board, :black)) }
        it 'cannot move to (2, 1)' do
          expect(get_moves).not_to include({ row: 2, col: 1 })
        end
      end

      context 'with same color piece on (3, 1)' do
        before { board.set_piece(3, 1, Knight.new(board, :white)) }
        it 'cannot move to (3, 1)' do
          expect(get_moves).not_to include({ row: 3, col: 1 })
        end
      end
    end

    context 'when placed at (6, 3)' do
      before { board.set_piece(6, 3, subject) }
      it 'can move one space forward' do
        expect(get_moves).to eql(Set.new([{ row: 7, col: 3 }]))
      end

      context 'with enemy king at (7, 4)' do
        before { board.set_piece(7, 4, King.new(board, :black)) }
        it 'can capture the king' do
          expect(get_moves).to include({ row: 7, col: 4 })
        end
      end
    end
  end
end