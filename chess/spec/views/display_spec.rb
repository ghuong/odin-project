require "views/display"
require "models/chess_board"

describe Display do

  let(:board) { ChessBoard.new }
  before { board.reset }

  describe '.board_to_string' do
    def expected_output
"   a b c d e f g h 
  ┌────────────────┐
 8│♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖ │8
 7│♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙ │7
 6│  ▩   ▩   ▩   ▩ │6
 5│▩   ▩   ▩   ▩   │5
 4│  ▩   ▩   ▩   ▩ │4
 3│▩   ▩   ▩   ▩   │3
 2│♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟ │2
 1│♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜ │1
  └────────────────┘
   a b c d e f g h 
"
    end

    it 'prints the correct output' do
      expect{ subject.display_board(board) }.to output(expected_output).to_stdout
    end
  end
end