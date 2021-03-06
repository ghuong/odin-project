module ChessBoardConstants
  # Number of rows and columns of a ChessBoard
  BOARD_DIMENSIONS = 8.freeze
  # Starting column for Kings
  KING_COLUMN = 4.freeze
  # Starting column for Queens
  QUEEN_COLUMN = 3.freeze
end

module GameStateConstants
  # Relative path to saved games directory
  SAVED_GAMES_DIR = "saved_games/".freeze
  # File extension for all saved games
  SAVED_GAME_EXTENSION = ".yml".freeze
  # Regular expression to retrieve all saved games with Dir[...]
  SAVED_GAMES_REGEX = SAVED_GAMES_DIR + "*" + SAVED_GAME_EXTENSION
end