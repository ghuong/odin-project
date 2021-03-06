require "yaml"

require "utilities/constants"

module GameSaver
  # Returns an array of id-title hashes of each saved game
  def self.get_list_of_saved_games
    saved_games = []
    if Dir.exist? GameStateConstants::SAVED_GAMES_DIR
      saved_games = Dir[GameStateConstants::SAVED_GAMES_REGEX]
    end

    saved_games.map do |filename|
      yaml = load_yaml_by_filename(filename)
      { id: yaml[:id], title: yaml[:title] }
    end
  end

  # Saves the given game to the saved games directory
  def self.save_game(game_id, title, game)
    Dir.mkdir(GameStateConstants::SAVED_GAMES_DIR) unless Dir.exists? GameStateConstants::SAVED_GAMES_DIR
    filename = get_save_file_name(game_id)
    game_state_yaml = YAML.dump(game)
    yaml = YAML.dump({ id: game_id, title: title, game_state_yaml: game_state_yaml })
    File.open(filename, "w") do |file|
      file.write(yaml)
    end
  end

  # Loads and returns the game object from the saved games directory
  # Else it returns nil
  def self.load_game_by_id(game_id)
    valid_ids = get_list_of_saved_games.map { |save| save[:id] }
    if not valid_ids.include? game_id then return nil end
    yaml = load_yaml_by_filename(get_save_file_name(game_id))
    YAML.load(yaml[:game_state_yaml])
  end

  # Loads the YAML from the given file
  def self.load_yaml_by_filename(filename)
    yaml = File.read filename
    YAML.load(yaml)
  end

  # Construct the name of the save file for the given game id
  def self.get_save_file_name(game_id)
    GameStateConstants::SAVED_GAMES_DIR + "game_#{game_id}" + GameStateConstants::SAVED_GAME_EXTENSION
  end

  # Get a unique game id
  def self.get_unique_id
    get_list_of_saved_games.length
  end
end