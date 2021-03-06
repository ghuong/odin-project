class TicTacToe
  def start_new_game
    reset
    puts "Welcome to Tic-Tac-Toe!"
    @board.display_board
    puts
    loop do
      row, col = prompt
      @board.submit_move(row, col, @current_player)
      @board.display_board
      puts
     break if @board.win?(row, col, @current_player)
      swap_players
    end
    puts
    puts "Player #{@current_player} wins!"
    puts
  end

  private
    def reset
      @board = TicTacToeBoard.new
      @current_player = TicTacToeBoard.PLAYERS[0]
      @next_player = TicTacToeBoard.PLAYERS[1]
    end

    def prompt
      puts "Player #{@current_player}'s turn. Enter row and column numbers separated by comma..."
      begin
        print " > "
        input = gets.chomp.split(",")
        if input.length != 2 then raise end
        row, col = input[0].to_i, input[1].to_i
        if not (@board.valid_row?(row) and
                @board.valid_col?(col) and
                @board.space_empty?(row, col)) 
          raise
        end
        puts
        return row, col
      rescue
        puts "Sorry, that input was invalid. Please try again..."
        retry
      end
    end

    def swap_players
      @current_player, @next_player = @next_player, @current_player
    end
end

class TicTacToeBoard
  PLAYERS = ["O", "X"].freeze

  def initialize
    @rows = []
    3.times { @rows.push([" ", " ", " "]) }
  end

  def display_board
    (0..1).each do |row|
      puts row_to_s(row)
      puts "---|---|---"
    end
    puts row_to_s(2)
  end

  def valid_row?(row)
    row >= 0 and row < @rows.length
  end

  def space_empty?(row, col)
    @rows[row][col] == " "
  end

  def valid_col?(col)
    col >= 0 and col < @rows[0].length
  end

  def submit_move(row, col, player)
    @rows[row][col] = player
  end

  def win?(row, col, player)
    row_win?(row, player) or col_win?(col, player) or
      diag_slash_win?(player) or diag_backslash_win?(player)
  end

  private
    def row_to_s(row)
      " " + @rows[row].join(" | ")
    end

    def row_win?(row, player)
      @rows[row].all? { |spot| spot == player }
    end

    def col_win?(col, player)
      @rows.all? { |row| row[col] == player }
    end

    def diag_slash_win?(player)
      @rows.each_with_index do |row, idx|
        return false if row[idx] != player
      end
      true
    end

    def diag_backslash_win?(player)
      @rows.each_with_index do |row, idx|
        return false if row[row.length-1-idx] != player
      end
      true
    end
end
