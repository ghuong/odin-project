require "utilities/constants"

module Display
  def self.display_game(game)
    display_board(game.board)
  end

  def self.display_board(board)
    print "   "
    ("a".."h").each { |col| print "#{col} " }
    print "\n"

    print "  \u250C"
    ChessBoardConstants::BOARD_DIMENSIONS.times { print "\u2500\u2500" }
    puts "\u2510"

    (ChessBoardConstants::BOARD_DIMENSIONS).downto(1).each do |row|
      print " #{row}\u2502"
      ChessBoardConstants::BOARD_DIMENSIONS.times do |col|
        piece = board.get_piece(row - 1, col)
        piece_string = piece_to_string(board.get_piece(row - 1, col)).encode("utf-8")
        piece_string = "\u25A9" if piece.is_blank_space? and
                                    ((col.odd? and row.even?) or (col.even? and row.odd?))
        print piece_string + " "
      end
      print "\u2502#{row}\n"
    end
    
    print "  \u2514"
    ChessBoardConstants::BOARD_DIMENSIONS.times { print "\u2500\u2500" }
    puts "\u2518"

    print "   "
    ("a".."h").each { |col| print "#{col} " }
    print "\n"
  end

  def self.piece_to_string(piece)
    if piece.is_blank_space? then return " " end

    case piece.color
    when :black
      case piece.get_type
      when :king
        "\u2654"
      when :queen
        "\u2655"
      when :bishop
        "\u2657"
      when :knight
        "\u2658"
      when :rook
        "\u2656"
      when :pawn
        "\u2659"
      end
    when :white
      case piece.get_type
      when :king
        "\u265A"
      when :queen
        "\u265B"
      when :bishop
        "\u265D"
      when :knight
        "\u265E"
      when :rook
        "\u265C"
      when :pawn
        "\u265F"
      end
    end
  end
end