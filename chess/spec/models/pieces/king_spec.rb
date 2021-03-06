require "set"

require "models/pieces/king"

describe King do

  let(:board) { ChessBoard.new }
  let(:subject) { King.new(board, :black) }

  describe '#get_moves' do
    def get_moves
      Set.new(subject.get_moves)
    end

    context 'when placed at (0, 0)' do
      before { board.set_piece(0, 0, subject) }

      def correct_moves
        Set.new([
          { row: 0, col: 1 },
          { row: 1, col: 1 },
          { row: 1, col: 0 }
        ])
      end

      it 'returns three correct moves' do
        expect(get_moves).to eql(correct_moves)
      end
    end

    context 'when placed at (2, 2)' do
      before { board.set_piece(2, 2, subject) }

      def correct_moves
        Set.new([
          { row: 3, col: 3 },
          { row: 3, col: 1 },
          { row: 1, col: 1 },
          { row: 1, col: 3 },
          { row: 3, col: 2 },
          { row: 2, col: 3 },
          { row: 1, col: 2 },
          { row: 2, col: 1 }
        ])
      end

      it 'returns eight correct moves' do
        expect(get_moves).to eql(correct_moves)
      end

      context 'with same color piece on (1, 2)' do
        before { board.set_piece(1, 2, Knight.new(board, :black)) }
        context 'with different color piece on (1, 1)' do
          before { board.set_piece(1, 1, Knight.new(board, :white)) }
          
          it 'cannot move to (1, 2)' do
            expect(get_moves).not_to include({ row: 1, col: 2 })
          end

          it 'can move to (1, 1)' do
            expect(get_moves).to include({ row: 1, col: 1 })
          end
        end

        context 'with enemy Rook pressuring column 3' do
          before { board.set_piece(7, 3, Rook.new(board, :white)) }
          it 'cannot move to column 3' do
            expect(get_moves).not_to include({ row: 1, col: 3 })
            expect(get_moves).not_to include({ row: 2, col: 3 })
            expect(get_moves).not_to include({ row: 3, col: 3 })
          end
        end
      end
    end
  end
end