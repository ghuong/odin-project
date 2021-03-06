require "models/pieces/rook"
require "models/chess_board"
require "models/pieces/shared_examples"

describe Rook do
  it_behaves_like "a rook"

  context 'when at (0, 0)' do
    before { board.set_piece(0, 0, subject) }
    let(:board) { ChessBoard.new }
    subject { Rook.new(board, :black) }

    it 'has fourteen moves' do
      expect(subject.get_moves.length).to eql(14)
    end
  end
end