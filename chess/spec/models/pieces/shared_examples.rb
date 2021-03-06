require "models/pieces/rook"
require "models/pieces/bishop"
require "models/chess_board"

shared_examples "a rook" do
  let(:board) { ChessBoard.new }
  let(:subject) { described_class.new(board, :black) }

  describe '#get_moves' do
    context 'when placed at (0, 0)' do
      before { board.set_piece(0, 0, subject) }

      def correct_moves
        [
          { row: 0, col: 1 },
          { row: 0, col: 2 },
          { row: 0, col: 3 },
          { row: 0, col: 4 },
          { row: 0, col: 5 },
          { row: 0, col: 6 },
          { row: 0, col: 7 },

          { row: 1, col: 0 },
          { row: 2, col: 0 },
          { row: 3, col: 0 },
          { row: 4, col: 0 },
          { row: 5, col: 0 },
          { row: 6, col: 0 },
          { row: 7, col: 0 },
        ]
      end

      it 'returns fourteen correct moves' do
        expect(subject.get_moves).to include(*correct_moves)
      end
    end

    context 'when placed at (4, 4)' do
      before { board.set_piece(4, 4, subject) }

      def correct_moves
        [
          { row: 4, col: 0 },
          { row: 4, col: 1 },
          { row: 4, col: 2 },
          { row: 4, col: 3 },
          { row: 4, col: 5 },
          { row: 4, col: 6 },
          { row: 4, col: 7 },

          { row: 0, col: 4 },
          { row: 1, col: 4 },
          { row: 2, col: 4 },
          { row: 3, col: 4 },
          { row: 5, col: 4 },
          { row: 6, col: 4 },
          { row: 7, col: 4 },
        ]
      end

      it 'returns fourteen correct moves' do
        expect(subject.get_moves).to include(*correct_moves)
      end

      context 'with same color piece on (4, 3)' do
        before { board.set_piece(4, 3, Knight.new(board, :black)) }
        context 'with different color piece on (5, 4)' do
          before { board.set_piece(5, 4, Knight.new(board, :white)) }

          it 'cannot move to (4, 3) nor (4, 2)' do
            expect(subject.get_moves).not_to include({ row: 4, col: 3 })
            expect(subject.get_moves).not_to include({ row: 4, col: 2 })
          end

          it 'can move to (5, 4), but not (6, 4)' do
            expect(subject.get_moves).to include({ row: 5, col: 4 })
            expect(subject.get_moves).not_to include({ row: 6, col: 4 })
          end
        end
      end
    end
  end
end

shared_examples "a bishop" do

  let(:board) { ChessBoard.new }
  let(:subject) { described_class.new(board, :black) }

  describe '#get_moves' do
    context 'when placed at (0, 0)' do
      before { board.set_piece(0, 0, subject) }

      def correct_moves
        [
          { row: 1, col: 1 },
          { row: 2, col: 2 },
          { row: 3, col: 3 },
          { row: 4, col: 4 },
          { row: 5, col: 5 },
          { row: 6, col: 6 },
          { row: 7, col: 7 }
        ]
      end

      it 'returns seven correct moves' do
        expect(subject.get_moves).to include(*correct_moves)
      end
    end

    context 'when placed at (4, 4)' do
      before { board.set_piece(4, 4, subject) }

      def correct_moves
        [
          { row: 0, col: 0 },
          { row: 1, col: 1 },
          { row: 2, col: 2 },
          { row: 3, col: 3 },
          { row: 5, col: 5 },
          { row: 6, col: 6 },
          { row: 7, col: 7 },

          { row: 3, col: 5 },
          { row: 2, col: 6 },
          { row: 1, col: 7 },

          { row: 5, col: 3 },
          { row: 6, col: 2 },
          { row: 7, col: 1 },
        ]
      end

      it 'returns thirteen correct moves' do
        expect(subject.get_moves).to include(*correct_moves)
      end

      context 'with same color piece on (6, 6)' do
        before { board.set_piece(6, 6, Knight.new(board, :black)) }
        context 'with different color piece on (2, 2)' do
          before { board.set_piece(2, 2, Knight.new(board, :white)) }

          it 'cannot move to (6, 6) nor (7, 7)' do
            expect(subject.get_moves).not_to include({ row: 6, col: 6 })
            expect(subject.get_moves).not_to include({ row: 7, col: 7 })
          end

          it 'can move to (2, 2), but not (1, 1)' do
            expect(subject.get_moves).to include({ row: 2, col: 2 })
            expect(subject.get_moves).not_to include({ row: 1, col: 1 })
          end
        end
      end
    end
  end
end