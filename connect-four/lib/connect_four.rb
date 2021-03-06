class ConnectFour
  MAX_HEIGHT = 6.freeze
  NUM_COLS = 7.freeze
  EMPTY_SPACE = "\u25EF".encode("utf-8")
  PLAYER_1_PIECE = "\u25C9".encode("utf-8")
  PLAYER_2_PIECE = "\u25CE".encode("utf-8")

  attr_reader :columns

  def initialize
    @turns = 0
    @columns = []
    NUM_COLS.times { @columns << [] }
  end

  def play
    loop do
      display_board
      column_index = do_turn
      if connect_four?(column_index)
        display_board
        puts "Game Over!"
        break
      elsif all_full?
        display_board
        puts "It's a tie!"
        break
      end
    end
  end

  def do_turn
    print "Player #{get_current_player}'s turn. Put #{get_player_piece}  in column: "
    loop do
      column_index = gets.chomp.to_i
      return column_index if move(column_index)
      print "Please try again: "
    end
  end

  def move(column_index)
    if not is_valid_column? column_index then return false end
    if @columns[column_index].length >= MAX_HEIGHT then return false end

    @columns[column_index] << get_current_player
    @turns += 1
    return true
  end

  def display_board
    print "     "
    NUM_COLS.times { |i| print "#{i}   " }
    print "\n"

    print "  |--"
    NUM_COLS.times { print "----" }
    print "|\n"
    (MAX_HEIGHT).downto(1).each do |height|
      print "  |  "
      (0...NUM_COLS).each do |column_index|
        print piece_to_string(column_index, height), "   "
      end
      print "|\n"
    end
    print "  |__"
    NUM_COLS.times { print "____" }
    print "|\n\n"
  end

  def piece_to_string(column_index, height)
    if @columns[column_index].length < height or height == 0
      EMPTY_SPACE
    else
      get_player_piece(@columns[column_index][height - 1])
    end
  end

  def get_player_piece(player = nil)
    if player.nil? then player = get_current_player end

    case player
    when 1
      PLAYER_1_PIECE
    when 2
      PLAYER_2_PIECE
    end
  end

  def get_current_player
    (@turns % 2) + 1
  end

  def connect_four?(last_played_column_index)
    if not is_valid_column?(last_played_column_index) then raise "Invalid column: #{last_played_column_index}" end

    height = @columns[last_played_column_index].length
    return (connect_four_vertical?(last_played_column_index, height) or 
      connect_four_horizontal?(last_played_column_index, height) or 
      connect_four_diagonally_down?(last_played_column_index, height) or
      connect_four_diagonally_up?(last_played_column_index, height))
  end

  # Compares the last played piece to other pieces (specified with the coordinates
  # in 'columns' and 'heights'), and returns the number of matching pieces. The
  # comparison is short-circuited as soon as one piece fails to match
  def connect_four_helper(last_played_column_index, column_indices, heights)
    last_played_height = @columns[last_played_column_index].length
    if column_indices.length != heights.length then raise "Invalid input" end

    matches = 0
    column_indices.each_with_index do |column_index, heights_array_index|
      break if not pieces_match?(last_played_column_index, last_played_height, 
                                 column_index, heights[heights_array_index])
      matches += 1
    end
    return matches
  end

  def connect_four_vertical?(last_played_column_index, height)
    columns = [last_played_column_index, last_played_column_index, last_played_column_index]
    heights = [height - 1, height - 2, height - 3]
    connect_four_helper(last_played_column_index, columns, heights) >= 3
  end

  def connect_four_horizontal?(last_played_column_index, height)
    heights = [height, height, height]
    left_columns = [last_played_column_index - 1, last_played_column_index - 2, last_played_column_index - 3]
    right_columns = [last_played_column_index + 1, last_played_column_index + 2, last_played_column_index + 3]

    connect_four_helper(last_played_column_index, left_columns, heights) +
    connect_four_helper(last_played_column_index, right_columns, heights) >= 3
  end

  def connect_four_diagonally_down?(last_played_column_index, height)
    left_heights = [height + 1, height + 2, height + 3]
    left_columns = [last_played_column_index - 1, last_played_column_index - 2, last_played_column_index - 3]

    right_heights = [height - 1, height - 2, height - 3]
    right_columns = [last_played_column_index + 1, last_played_column_index + 2, last_played_column_index + 3]

    connect_four_helper(last_played_column_index, left_columns, left_heights) +
    connect_four_helper(last_played_column_index, right_columns, right_heights) >= 3
  end

  def connect_four_diagonally_up?(last_played_column_index, height)
    left_heights = [height - 1, height - 2, height - 3]
    left_columns = [last_played_column_index - 1, last_played_column_index - 2, last_played_column_index - 3]

    right_heights = [height + 1, height + 2, height + 3]
    right_columns = [last_played_column_index + 1, last_played_column_index + 2, last_played_column_index + 3]

    connect_four_helper(last_played_column_index, left_columns, left_heights) +
    connect_four_helper(last_played_column_index, right_columns, right_heights) >= 3
  end

  # Returns true iff the pieces of the given coordinates match
  # If either piece does not exist, it returns false 
  def pieces_match?(this_column, this_height, that_column, that_height)
    this_height > 0 and that_height > 0 and
    is_valid_column?(this_column) and is_valid_column?(that_column) and
    @columns[this_column].length >= this_height and @columns[that_column].length >= that_height and
    @columns[this_column][this_height - 1] == @columns[that_column][that_height - 1]
  end

  def is_valid_column?(column_index)
    (0...NUM_COLS).cover? column_index
  end

  def all_full?
    @columns.all? { |column| column.length >= MAX_HEIGHT }
  end
end