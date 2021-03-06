require "models/pieces/chess_piece"
require "utilities/constants"

# Bishop game piece
class Bishop < ChessPiece
include ChessPieceHelpers

  def get_type
    :bishop
  end

  # Bishop can move any number of spaces diagonally,
  # but cannot jump over other pieces
  def get_moves
    get_diagonal_moves
  end
end