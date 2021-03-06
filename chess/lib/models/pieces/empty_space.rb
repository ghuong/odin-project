require "models/pieces/chess_piece"

# This represents an empty space on the ChessBoard
class EmptySpace < ChessPiece
  def initialize
    super(nil, nil)
  end

  def get_type
    :empty
  end
end