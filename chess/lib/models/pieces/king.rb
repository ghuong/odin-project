require "models/pieces/chess_piece"
require "models/chess_game"
require "utilities/constants"

# King game piece
class King < ChessPiece
include ChessPieceHelpers

  def get_type
    :king
  end

  def get_moves
    get_adjacent_spaces.select do |move|
      [:blank_space, :enemy_piece].include? describe_location(move[:row], move[:col]) and
        (is_enemy_king?(move[:row], move[:col]) or not is_under_attack?(move[:row], move[:col]))
    end
  end

  def get_adjacent_spaces
    [
      { row: @row + 1, col: @col },
      { row: @row - 1, col: @col },
      { row: @row, col: @col + 1 },
      { row: @row, col: @col - 1 },
      { row: @row + 1, col: @col + 1 },
      { row: @row + 1, col: @col - 1 },
      { row: @row - 1, col: @col + 1 },
      { row: @row - 1, col: @col - 1 },
    ]
  end

  def is_enemy_king?(row, col)
    piece = @board.get_piece(row, col)
    return (not piece.is_blank_space? and piece.get_type == :king and piece.color == ChessGame.get_enemy_color(@color))
  end

  # Returns true iff the given space is under attack, assuming this King moves there
  def is_under_attack?(row = @row, col = @col)
    hypothetical_board = @board.get_copy
    hypothetical_board.move(@row, @col, row, col)
    enemy_color = ChessGame.get_enemy_color(@color)
    hypothetical_board.each_piece.any? do |piece|
      not piece.is_blank_space? and piece.color == enemy_color and
        ((piece.get_type != :king and piece.get_moves.include?({ row: row, col: col })) or
         (piece.get_type == :king and piece.get_adjacent_spaces.include?({ row: row, col: col })))
    end
  end
end