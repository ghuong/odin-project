require "models/chess_board"

describe ChessBoard do

  context 'my color is black' do
    let(:my_color) { :black }

    context 'when there is a white knight at (3, 3)' do
      before { subject.set_piece(3, 3, Knight.new(subject, :white)) }

      describe '#reset' do
        before { subject.reset }

        it 'is gone after resetting' do
          expect(subject.get_piece(3, 3).is_blank_space?).to be true
        end

        it 'has white king at (0, 4)' do
          expect(subject.get_piece(0, 4).get_type).to eql(:king)
          expect(subject.get_piece(0, 4).color).to eql(:white)
        end

        it 'has a black queen at (7, 3)' do
          expect(subject.get_piece(7, 3).get_type).to eql(:queen)
          expect(subject.get_piece(7, 3).color).to eql(:black)
        end

        it 'means no piece has moved yet' do
          expect(subject.get_piece(0, 4).has_moved).to be false
        end
      end
    end

    describe '#can_move' do
      context 'when there is a white knight at (3, 3)' do
        before { subject.set_piece(3, 3, Knight.new(subject, :white)) }

        it 'cannot be moved' do
          expect(subject.can_move?(3, 3, 4, 5, my_color)).to be false
        end
      end

      context 'when there is a black knight at (3, 3)' do
        before { subject.set_piece(3, 3, Knight.new(subject, :black)) }

        it 'can be moved to (4, 5)' do
          expect(subject.can_move?(3, 3, 4, 5, my_color)).to be true
        end

        it 'cannot be moved to (0, 0)' do
          expect(subject.can_move?(3, 3, 0, 0, my_color)).to be false
        end

        it 'cannot move a blank space' do
          expect(subject.can_move?(0, 0, 1, 2, my_color)).to be false
        end
      end
    end

    describe '#move' do
      context 'when there is a black knight at (3, 3)' do
        before { subject.set_piece(3, 3, Knight.new(subject, :black)) }

        context 'after moving it to (4, 5)' do
          before { subject.move(3, 3, 4, 5) }

          it 'is located at (4, 5)' do
            expect(subject.get_piece(4, 5).get_type).to eql(:knight)
          end

          it 'is vacant at (3, 3)' do
            expect(subject.get_piece(3, 3).is_blank_space?).to be true
          end

          it 'has moved' do
            expect(subject.get_piece(4, 5).has_moved).to be true
          end
        end
      end
    end

    describe '#conventional_coordinates_to_indices' do
      context 'given row: "2", col: "D"' do
        it 'returns [1, 3]' do
          expect(ChessBoardHelpers.conventional_coordinates_to_indices("2", "D")).to eql([1, 3])
        end
      end
    end
  end
end