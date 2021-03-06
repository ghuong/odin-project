require "models/pieces/bishop"
require "models/chess_board"
require "models/pieces/shared_examples"

describe Bishop do
  it_behaves_like "a bishop"

  context 'when at (0, 0)' do
    before { board.set_piece(0, 0, subject) }
    let(:board) { ChessBoard.new }
    subject { Bishop.new(board, :black) }

    it 'has seven moves' do
      expect(subject.get_moves.length).to eql(7)
    end
  end
end