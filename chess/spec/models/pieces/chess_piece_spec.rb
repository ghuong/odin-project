require "models/pieces/chess_piece"

describe ChessPiece do

  let(:old_board) { ChessBoard.new }
  let(:color) { :white }
  let(:type) { :knight }
  subject { Knight.new(old_board, color) }

  describe '.get_new_piece' do
    context 'when given type :knight' do
      it 'is a knight' do
        expect(ChessPiece.get_new_piece(old_board, color, type).get_type).to eql(type)
      end
    end
  end

  describe '#get_copy' do
    let(:new_board) { ChessBoard.new }

    it 'returns a knight' do
      expect(subject.get_copy(new_board).get_type).to eql(type)
    end

    it 'returns a copy' do
      expect(subject.get_copy(new_board)).not_to equal(subject)
    end

    it 'is not a blank space' do
      expect(subject.get_copy(new_board).is_blank_space?).to be false
    end
  end
end