require "models/chess_game"
require "views/display"

describe ChessGame do

  let(:id) { 12 }
  subject { ChessGame.new(id) }

  context 'given id 12' do
    it 'has the given id' do
      expect(subject.id).to eql(id)
    end 
  end

  it 'has starting player :white' do
    expect(subject.get_current_player).to eql(:white)
  end

  describe '.get_enemy_color' do
    context 'given :white' do
      it 'returns :black' do
        expect(ChessGame.get_enemy_color(:white)).to eql(:black)
      end
    end

    context 'given :black' do
      it 'returns :white' do
        expect(ChessGame.get_enemy_color(:black)).to eql(:white)
      end
    end
  end

  describe '#checkmate?' do
    context 'upon initializing' do
      it 'returns false' do
        expect(subject.checkmate?(:black)).to be false
      end
    end

    context 'when white does 4-move checkmate' do
      before do
        subject.board.move(0, 3, 2, 5) # queen moves
        subject.board.move(0, 5, 6, 5) # bishop moves
      end

      it 'is checkmate' do
        expect(subject.checkmate?(:black)).to be true
      end
    end
  end

  describe '#can_castle?' do
    def expect_can_castle(can_castle = true)
      expect(subject.can_castle?(direction, color)).to be can_castle
    end

    context 'given color black' do
      let(:color) { :black }
      let(:king) { subject.board.get_piece(7, 4) }

      context 'given direction right' do
        let(:direction) { :right }
        let(:rook) { subject.board.get_piece(7, 7) }

        context 'when there are no pieces in-between' do
          before do
            subject.board.set_piece(7, 5)
            subject.board.set_piece(7, 6)
          end

          context 'when rook has moved' do
            before { rook.has_moved = true }
            it 'returns false' do
              expect_can_castle(false)
            end
          end

          context 'when king has moved' do
            before { king.has_moved = true }
            it 'returns false' do
              expect_can_castle(false)
            end
          end

          context 'when neither king nor rook have moved' do
            context 'when king is not in check' do
              it 'returns true' do
                expect_can_castle
              end
            end
          end
        end

        context 'when there is one piece in-between' do
          before { subject.board.set_piece(7, 5) }
          context 'when neither king nor rook have moved' do
            it 'returns false' do
              expect_can_castle(false)
            end
          end
        end
      end

      context 'given direction left' do
        let(:direction) { :left }
        let(:rook) { subject.board.get_piece(7, 0) }

        context 'when neither king nor rook have moved' do
          context 'when there are no pieces in-between' do
            before do
              subject.board.set_piece(7, 1)
              subject.board.set_piece(7, 2)
              subject.board.set_piece(7, 3)
            end
            context 'when king is not in check' do
              it 'returns true' do
                expect_can_castle
              end
            end

            context 'when king is in check by a knight' do
              before { subject.board.set_piece(5, 3, Knight.new(subject.board, :white)) }

              it 'is in check' do
                expect(subject.board.get_piece(7, 4).is_under_attack?).to be true
              end

              it 'returns false' do
                expect_can_castle(false)
              end
            end

            context 'when king is in check by a pawn' do
              before { subject.board.set_piece(6, 3, Pawn.new(subject.board, :white)) }

              it 'is in check' do
                expect(subject.board.get_piece(7, 4).is_under_attack?).to be true
              end

              it 'returns false' do
                expect_can_castle(false)
              end
            end

            context 'when king passes through space which is under-attack' do
              before { subject.board.set_piece(6, 3, Rook.new(subject.board, :white)) }
              it 'returns false' do
                expect_can_castle(false)
              end
            end

            context 'when king lands on space which is under-attack' do
              before { subject.board.set_piece(6, 2, Rook.new(subject.board, :white)) }
              it 'returns false' do
                expect_can_castle(false)
              end
            end

            context 'when space that rook crosses is under-attack' do
              before { subject.board.set_piece(6, 1, Rook.new(subject.board, :white)) }
              it 'returns true' do
                expect_can_castle
              end
            end
          end

          context 'when there is one piece in-between' do
            before do
              subject.board.set_piece(7, 1)
              subject.board.set_piece(7, 2)
            end

            it 'returns false' do
              expect_can_castle(false)
            end
          end
        end
      end
    end
  end

  describe '#castle' do
    def expect_proper_castle(king_row, king_col, rook_row, rook_col)
      subject.castle(direction, color)
      Display.display_game(subject)
      expect(subject.board.get_piece(king_row, king_col).get_type).to eql(:king)
      expect(subject.board.get_piece(rook_row, rook_col).get_type).to eql(:rook)
      expect(subject.board.get_piece(king_row, king_col).color).to eql(color)
      expect(subject.board.get_piece(king_row, king_col).color).to eql(color)
    end

    context 'given color black' do
      let(:color) { :black }
      context 'given direction left' do
        let(:direction) { :left }
        it 'castles properly' do
          expect_proper_castle(7, 2, 7, 3)
        end
      end

      context 'given direction right' do
        let(:direction) { :right }
        it 'castles properly' do
          expect_proper_castle(7, 6, 7, 5)
        end
      end
    end

    context 'given color white' do
      let(:color) { :white }
      context 'given direction left' do
        let(:direction) { :left }
        it 'castles properly' do
          expect_proper_castle(0, 2, 0, 3)
        end
      end

      context 'given direction right' do
        let(:direction) { :right }
        it 'castles properly' do
          expect_proper_castle(0, 6, 0, 5)
        end
      end
    end
  end

  describe 'en passant move' do
    context 'when pawn moves forward one space' do
      before { subject.move("2", "A", "3", "A") }
      it 'is not vulnerable to en passant on following turn' do
        pawn = subject.board.get_piece(2, 0)
        expect(pawn.get_type).to eql(:pawn)
        expect(pawn.is_vulnerable_to_en_passant?).to be false
      end
    end

    context 'when white pawn moves forward two spaces' do
      let(:victim_pawn) { subject.board.get_piece(3, 0) }
      let(:attacker_pawn) { subject.board.get_piece(3, 1) }
      before do
        subject.move("2", "A", "4", "A")
        subject.board.set_piece(3, 1, Pawn.new(subject.board, :black))
      end
      it 'is vulnerable to en passant on following turn' do
        expect(victim_pawn.get_type).to eql(:pawn)
        expect(victim_pawn.is_vulnerable_to_en_passant?).to be true
      end

      it 'can be captured by enemy pawn "en passant"' do
        expect(subject.can_move?("4", "B", "3", "A")).to be true
      end

      it 'is captured after "en passant" move' do
        subject.move("4", "B", "3", "A")
        expect(subject.board.get_piece(3, 0).is_blank_space?).to be true
      end

      context 'but opponent ignores it' do
        before do
          subject.board.advance_turn
          subject.board.advance_turn
        end
        it 'is no longer vulnerable to en passant' do
          expect(victim_pawn.is_vulnerable_to_en_passant?).to be false
          expect(subject.can_move?("4", "B", "3", "A")).to be false
        end
      end
    end
  end

  describe 'pawn promotion' do
    context 'when white pawn reaches last rank' do
      before { subject.board.set_piece(7, 0, Pawn.new(subject.board, :white)) }
      it 'is a pawn promotion' do
        expect(subject.is_pawn_promotion?("8", "A")).to be true
      end
    end
  end
end