require "utilities/game_saver"
require "models/chess_game"

# Helper methods to be mixed into the chess states
module UmpireHelpers
  def self.get_new_game
    id = GameSaver.get_unique_id
    ChessGame.new(id)
  end

  def self.exist_any_saves?
    saved_games = GameSaver.get_list_of_saved_games
    not saved_games.nil? and not saved_games.empty?
  end

  def self.display_invalid_command_warning
    puts "Sorry, I do not understand your input."
  end
end