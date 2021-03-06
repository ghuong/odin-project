require "models/pieces/chess_piece"

# Pawn chess piece
class Pawn < ChessPiece
  def initialize(board, color)
    super(board, color)
    @vulnerable_turn = -1
  end

  def get_type
    :pawn
  end

  def get_moves
    direction_sign = @color == :white ? 1 : -1
    starting_row = Pawn.get_starting_row(@color)

    moves = [{ row: @row + (1 * direction_sign), col: @col }]
    if @row == starting_row
      moves << { row: @row + (2 * direction_sign), col: @col }
    end

    moves.select! do |move|
      :blank_space == describe_location(move[:row], move[:col])
    end

    attack_moves = [
      { row: @row + (1 * direction_sign), col: @col - 1 },
      { row: @row + (1 * direction_sign), col: @col + 1 }
    ].each do |move|
      if [:enemy_piece].include? describe_location(move[:row], move[:col])
        moves << move
      elsif not get_en_passant_capture(move).nil?
        moves << move
      end
    end

    return moves
  end

  # Return the captured pawn "en passant" if applicable, else nil
  def get_en_passant_capture(move)
    if move[:col] == @col then return nil end

    is_moving_to_blank = describe_location(move[:row], move[:col]) == :blank_space
    side_piece = @board.get_piece(@row, move[:col])
    is_passing_enemy_pawn = (describe_location(@row, move[:col]) == :enemy_piece and
                             side_piece.get_type == :pawn and
                             side_piece.is_vulnerable_to_en_passant?)
    if is_moving_to_blank and is_passing_enemy_pawn
      return side_piece
    else
      return nil
    end
  end

  def is_vulnerable_to_en_passant?
    @board.turn == @vulnerable_turn
  end

  def notify(start_row, start_col)
    super(start_row, start_col)
    if (@row - start_row).abs == 2
      @vulnerable_turn = @board.turn + 1
    end
  end

  def self.get_starting_row(color)
    case color
    when :white
      1
    when :black
      ChessBoardConstants::BOARD_DIMENSIONS - 2
    end
  end
end