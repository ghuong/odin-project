require "utilities/constants"
require "utilities/chess_board_helpers"
require "models/pieces/empty_space"

# Holds bare minimum state for the chess board
class ChessBoard
include ChessBoardHelpers

  attr_reader :turn

  def initialize
    @board = []
    ChessBoardConstants::BOARD_DIMENSIONS.times do |row|
      @board << [EmptySpace.new] * ChessBoardConstants::BOARD_DIMENSIONS
    end
    @turn = 0
  end

  # Returns the ChessPiece at the given coordinates
  # Returns nil if coordinates are invalid
  def get_piece(row, col)
    if not is_valid_coordinates?(row, col) then return nil end
    
    @board[row][col]
  end

  # Sets the ChessPiece at the given coordinates
  # If no piece provided, sets to EmptySpace
  # Returns true iff coordinates are valid
  def set_piece(row, col, piece = nil)
    if not is_valid_coordinates?(row, col) then return false end

    if piece.nil? then piece = EmptySpace.new end
    @board[row][col] = piece
    piece.row = row
    piece.col = col
    return true
  end

  # Returns true iff the given coordinates are within the dimensions of the board
  def is_valid_coordinates?(row, col)
    (0...ChessBoardConstants::BOARD_DIMENSIONS).cover?(row) and
    (0...ChessBoardConstants::BOARD_DIMENSIONS).cover?(col)
  end

  def advance_turn
    @turn += 1
  end

  def get_copy
    copy_board = ChessBoard.new
    ChessBoardConstants::BOARD_DIMENSIONS.times do |row|
      ChessBoardConstants::BOARD_DIMENSIONS.times do |col|
        copy_board.set_piece(row, col, get_piece(row, col).get_copy(copy_board))
      end
    end
    return copy_board
  end
end