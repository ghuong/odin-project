require "yaml"

# Umpire for Hangman game
class HangmanUmpire
  SAVED_GAME_EXTENSION = ".save.yaml"
  SAVED_GAMES_DIR = "./saved_games/"
  SAVED_GAMES_PATH = SAVED_GAMES_DIR + "*" + SAVED_GAME_EXTENSION

  def initialize
    puts " --== Hangman ==--"
    @game = (prompt_user_to_load_game or start_new_game)
    play_game
  end

private
  def play_game
    @game.display_game_status
    loop do
      letter = prompt_player_to_guess_letter
      case letter.downcase
      when "save"
        save_game
        puts "Game save_#{@game.game_id} saved!"
        puts
        next
      when "exit"
        puts "See you later!"
        puts
        break
      end

      @game.guess_letter(letter)
      @game.display_game_status

      if @game.did_player_win?
        @game.display_word_status
        puts "You Win!"
        puts
        break
      elsif @game.did_player_lose?
        @game.display_word_status
        puts "You Lose!"
        puts
        break
      end
    end
  end

  # Prompt user if they wish to load a game
  # Return loaded game, or false
  def prompt_user_to_load_game
    saved_games = get_saved_games
    if saved_games.empty? then return false end

    print "Would you like to load a saved game? [y/N]: "
    input = gets.chomp.downcase
    puts
    if input != "y" then return false end

    if saved_games.length == 1 then return load_game(saved_games[0]) end

    saved_games.each_with_index do |saved_game, index|
      saved_game_name = saved_game.gsub(/\.save\.yaml/, "")
      puts "(#{index}) #{saved_game_name}"
    end
    puts
    print "Enter number: "
    save_number = gets.chomp.to_i
    puts
    if not (0...saved_games.length).cover?(save_number)
      save_number = 0
    end

    puts "Loading game #{save_number}..."
    return load_game(saved_games[save_number])
  end

  def get_saved_games
    saved_games = []
    if Dir.exist?(SAVED_GAMES_DIR)
      saved_games = Dir[SAVED_GAMES_PATH]
    end
    return saved_games
  end

  def get_num_saved_games
    get_saved_games.length
  end

  # Create a new HangmanGameState, and return it
  def start_new_game
    puts "Welcome to Hangman! Try to guess my secret word!"
    puts
    game_id = get_num_saved_games
    return HangmanGameState.new(game_id)
  end

  def save_game
    game_yaml = @game.to_yaml
    Dir.mkdir(SAVED_GAMES_DIR) unless Dir.exists? SAVED_GAMES_DIR
    filename = SAVED_GAMES_DIR + "save_#{@game.game_id}" + SAVED_GAME_EXTENSION
    File.open(filename, "w") do |file|
      file.puts game_yaml
    end
  end

  def load_game(filename)
    game_yaml = File.read filename
    return HangmanGameState.from_yaml(game_yaml)
  end

  def prompt_player_to_guess_letter
    puts "(Type 'save' to save game, or 'exit' at anytime)"
    print "Guess a letter: "
    loop do
      player_guess = gets.chomp
      return player_guess if letter?(player_guess) or player_guess.downcase == "save"
      print "Please try again: "
    end
    print "\n\n"
  end

  def letter?(lookAhead)
    lookAhead =~ /[[:alpha:]]/
  end
end

class HangmanGameState
  DICTIONARY_FILE_NAME = "5desk.txt"
  MIN_WORD_LENGTH = 5
  MAX_WORD_LENGTH = 12
  NUM_INCORRECT_GUESSES = 6

  attr_reader :game_id

  def initialize(game_id, word = nil, correct_letter_guesses = nil, incorrect_letter_guesses = nil)
    dictionary = load_dictionary(DICTIONARY_FILE_NAME)
    @game_id = game_id
    @word = (word or get_random_word(dictionary, MIN_WORD_LENGTH, MAX_WORD_LENGTH))
    @correct_letter_guesses = (correct_letter_guesses or [" "])
    @incorrect_letter_guesses = (incorrect_letter_guesses or [])
  end

  def guess_letter(letter)
    letter.upcase!
    if @word.include?(letter)
      @correct_letter_guesses.push(letter)
      puts "CORRECT! My word has letter #{letter}!"
    elsif not @incorrect_letter_guesses.include?(letter)
      @incorrect_letter_guesses.push(letter)
      @incorrect_letter_guesses.sort!
      puts "WRONG! My word has no letter #{letter}!"
    end
    puts
  end

  def display_word_status
    @word.each_char do |char|
      if @correct_letter_guesses.include?(char) 
        print char 
      else
        print "_"
      end
      print " "
    end
    puts
  end

  def display_game_status
    display_word_status

    if not @incorrect_letter_guesses.empty?
      print "Wrong Letters: ", @incorrect_letter_guesses.join(" ")
    end

    remaining_life = get_life_remaining
    print " (", remaining_life.to_s
    if remaining_life > 1 
      print " Lives Left)"
    else
      print " Life Left!)"
    end
  
    print "\n\n"
  end

  def did_player_win?
    @word.chars.all? { |char| @correct_letter_guesses.include?(char) }
  end

  def did_player_lose?
    get_life_remaining <= 0
  end

  def to_yaml
    YAML.dump({
      game_id: @game_id,
      word: @word,
      correct_letter_guesses: @correct_letter_guesses,
      incorrect_letter_guesses: @incorrect_letter_guesses
    })
  end

  def self.from_yaml(string)
    data = YAML.load string
    self.new(data[:game_id], data[:word], data[:correct_letter_guesses],
      data[:incorrect_letter_guesses])
  end

private

  # load 5desk.txt dictionary
  def load_dictionary(file_name)
    dictionary_file = File.read file_name
    dictionary = dictionary_file.split("\n")
    dictionary.map! { |word| word.strip!.upcase! }
    dictionary.select! { |word| not (word.nil? or word.empty?) }
    return dictionary
  end

  # randomly select a word 5-12 chars long
  def get_random_word(dictionary, min_length, max_length)
    random_word = nil
    loop do
      random_index = rand(dictionary.length)
      random_word = dictionary[random_index]
      break if not random_word.nil? and
        (min_length..max_length).cover? random_word.length
    end
    return random_word
  end

  def get_life_remaining
    NUM_INCORRECT_GUESSES - @incorrect_letter_guesses.length
  end
end

hangman = HangmanUmpire.new