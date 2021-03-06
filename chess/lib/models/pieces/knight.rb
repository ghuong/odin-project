require "models/pieces/chess_piece"

# Knight chess piece
class Knight < ChessPiece
  def get_type
    :knight
  end

  # The Knight can move in a L-shape, within the board,
  # and never attacking an allied piece
  def get_moves
    [
      { row: @row + 1, col: @col + 2 },
      { row: @row + 1, col: @col - 2 },
      { row: @row + 2, col: @col + 1 },
      { row: @row + 2, col: @col - 1 },
      { row: @row - 1, col: @col + 2 },
      { row: @row - 1, col: @col - 2 },
      { row: @row - 2, col: @col + 1 },
      { row: @row - 2, col: @col - 1 }
    ].select do |move|
      [:blank_space, :enemy_piece].include? describe_location(move[:row], move[:col])
    end
  end
end