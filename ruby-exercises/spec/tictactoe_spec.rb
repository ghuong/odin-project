require "tictactoe"

describe TicTacToeBoard do

  describe "#win?" do
    context "when top row is filled with O's" do
      def prepared_board
        ttt = TicTacToeBoard.new
        ttt.submit_move(0, 0, winning_player)
        ttt.submit_move(0, 1, winning_player)
        ttt.submit_move(0, 2, winning_player)
        return ttt
      end

      subject(:board) { prepared_board }
      let(:winning_player) { TicTacToeBoard::PLAYERS[0] }
      let(:losing_player) { TicTacToeBoard::PLAYERS[1] }

      it "means that player wins" do
        expect(board.win?(0, 0, winning_player)).to be true
      end

      it "means other player doesn't win" do
        expect(board.win?(0, 0, losing_player)).to be false
      end
    end

    context "when diagonal (from top-left) is filled with X's" do
      def prepared_board
        ttt = TicTacToeBoard.new
        ttt.submit_move(0, 0, winning_player)
        ttt.submit_move(1, 1, winning_player)
        ttt.submit_move(2, 2, winning_player)
        return ttt
      end

      subject(:board) { prepared_board }
      let(:winning_player) { TicTacToeBoard::PLAYERS[1] }
      let(:losing_player) { TicTacToeBoard::PLAYERS[0] }

      it "means that player wins" do
        expect(board.win?(0, 0, winning_player)).to be true
      end

      it "means other player doesn't win" do
        expect(board.win?(0, 0, losing_player)).to be false
      end
    end

    context "when diagonal (from top-right) is filled with O's" do
      def prepared_board
        ttt = TicTacToeBoard.new
        ttt.submit_move(0, 2, winning_player)
        ttt.submit_move(1, 1, winning_player)
        ttt.submit_move(2, 0, winning_player)
        return ttt
      end

      subject(:board) { prepared_board }
      let(:winning_player) { TicTacToeBoard::PLAYERS[0] }
      let(:losing_player) { TicTacToeBoard::PLAYERS[1] }

      it "means that player wins" do
        expect(board.win?(0, 2, winning_player)).to be true
      end

      it "means other player doesn't win" do
        expect(board.win?(0, 2, losing_player)).to be false
      end
    end

    context "when middle column is filled with X's" do
      def prepared_board
        ttt = TicTacToeBoard.new
        ttt.submit_move(0, 1, winning_player)
        ttt.submit_move(1, 1, winning_player)
        ttt.submit_move(2, 1, winning_player)
        return ttt
      end

      subject(:board) { prepared_board }
      let(:winning_player) { TicTacToeBoard::PLAYERS[1] }
      let(:losing_player) { TicTacToeBoard::PLAYERS[0] }

      it "means that player wins" do
        expect(board.win?(1, 1, winning_player)).to be true
      end

      it "means other player doesn't win" do
        expect(board.win?(1, 1, losing_player)).to be false
      end
    end
  end
end