require "models/chess_board"

# Defines a chess piece; note that "empty spaces" are also pieces
# This class should not be instantiated directly
class ChessPiece
  attr_accessor :row, :col, :board, :has_moved
  attr_reader :color

  def initialize(board, color)
    @board = board
    @color = color
    @has_moved = false
  end

  # Return the symbol representing the class
  def get_type; raise NotImplementedError end

  # Return an array of legal moves
  # if ignore_allies flag is set to true, then assume that all
  # allied pieces are enemy pieces
  def get_moves; raise NotImplementedError end

  # Notify this piece that it has just moved, and from where
  def notify(start_row, start_col)
    @has_moved = true
  end

  def describe_location(row, col)
    if not @board.is_valid_coordinates?(row, col)
      return :off_board
    else
      piece = @board.get_piece(row, col)
      if piece.is_blank_space?
        :blank_space
      elsif piece.color == @color
        :ally_piece
      else
        :enemy_piece
      end
    end
  end

  # Returns true iff this "piece" represents an empty space on the ChessBoard
  def is_blank_space?
    get_type == :empty
  end

  # Return deep copy of the piece
  def get_copy(board)
    copy_piece = ChessPiece.get_new_piece(board, @color, get_type)
    copy_piece.row = @row
    copy_piece.col = @col
    copy_piece.has_moved = @has_moved
    return copy_piece
  end

  def self.get_new_piece(board, color, type)
    case type
    when :bishop
      Bishop.new(board, color)
    when :king
      King.new(board, color)
    when :knight
      Knight.new(board, color)
    when :pawn
      Pawn.new(board, color)
    when :queen
      Queen.new(board, color)
    when :rook
      Rook.new(board, color)
    when :empty
      EmptySpace.new
    end
  end
end

# Non-essential helper methods for Chess Pieces
module ChessPieceHelpers
  # Return all legal moves, if moving straight
  def get_straight_moves
    north_moves = []
    south_moves = []
    west_moves = []
    east_moves = []
    (1...ChessBoardConstants::BOARD_DIMENSIONS).each do |step|
      north_moves << { row: @row + step, col: @col }
      south_moves << { row: @row - step, col: @col }
      west_moves << { row: @row, col: @col - step }
      east_moves << { row: @row, col: @col + step }
    end
    return select_legal_moves(north_moves) +
           select_legal_moves(south_moves) +
           select_legal_moves(west_moves) +
           select_legal_moves(east_moves)
  end

  # Return all legals moves, if moving diagonally
  def get_diagonal_moves
    northwest_moves = []
    northeast_moves = []
    southwest_moves = []
    southeast_moves = []
    (1...ChessBoardConstants::BOARD_DIMENSIONS).each do |step|
      northwest_moves << { row: @row + step, col: @col - step }
      northeast_moves << { row: @row + step, col: @col + step }
      southwest_moves << { row: @row - step, col: @col - step }
      southeast_moves << { row: @row - step, col: @col + step }
    end
    return select_legal_moves(northwest_moves) +
           select_legal_moves(northeast_moves) +
           select_legal_moves(southwest_moves) +
           select_legal_moves(southeast_moves)
  end

  # Loop through the given array 'moves', upon reaching
  # any piece, remove all subsequent moves
  def select_legal_moves(moves)
    legal_moves = []
    moves.each do |move|
      description = describe_location(move[:row], move[:col])
      
      if [:blank_space, :enemy_piece].include? description
        legal_moves << move
      end

      break if description != :blank_space
    end
    return legal_moves
  end
end