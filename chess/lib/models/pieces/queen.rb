require "models/pieces/chess_piece"
require "utilities/constants"

# Queen game piece
class Queen < ChessPiece
include ChessPieceHelpers

  def get_type
    :queen
  end

  def get_moves
    get_straight_moves + get_diagonal_moves
  end
end