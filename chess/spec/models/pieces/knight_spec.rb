require "set"

require "models/pieces/knight.rb"
require "models/chess_board.rb"

describe Knight do

  let(:board) { ChessBoard.new }
  subject { Knight.new(board, :black) }

  it 'is the given color' do
    expect(subject.color).to eql(:black)
  end

  describe '#get_moves' do
    def get_moves
      Set.new(subject.get_moves)
    end

    context 'when placed at (1, 1)' do
      before { board.set_piece(1, 1, subject) }

      def correct_moves
        Set.new([
          {row: 0, col: 3},
          {row: 2, col: 3},
          {row: 3, col: 2},
          {row: 3, col: 0}
        ])
      end

      it 'returns the four correct moves' do
        expect(get_moves).to eql(correct_moves)
      end
    end

    context 'when placed at (6, 5)' do
      before { board.set_piece(6, 5, subject) }

      def correct_moves
        Set.new([
          {row: 7, col: 3},
          {row: 5, col: 3},
          {row: 4, col: 4},
          {row: 4, col: 6},
          {row: 5, col: 7},
          {row: 7, col: 7}
        ])
      end

      it 'returns the six correct moves' do
        expect(get_moves).to eql(correct_moves)
      end
    end

    context 'when placed at (3, 3)' do
      before { board.set_piece(3, 3, subject) }

      def correct_moves
        Set.new([
          {row: 5, col: 2},
          {row: 5, col: 4},
          {row: 4, col: 5},
          {row: 2, col: 5},
          {row: 1, col: 4},
          {row: 1, col: 2},
          {row: 2, col: 1},
          {row: 4, col: 1}
        ])
      end

      it 'returns the eight correct moves' do
        expect(get_moves).to eql(correct_moves)
      end

      context 'with same color piece on (4, 5)' do
        before { board.set_piece(4, 5, Knight.new(nil, :black)) }
        context 'with different color piece on (2, 5)' do
          before { board.set_piece(2, 5, Knight.new(nil, :white)) }
          it 'cannot move to (4, 5)' do
            expect(get_moves).not_to include({row: 4, col: 5})
          end

          it 'can move to (2, 5)' do
            expect(get_moves).to include({row: 2, col: 5})
          end
        end
      end
    end
  end
end