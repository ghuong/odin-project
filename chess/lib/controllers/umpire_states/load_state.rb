require "controllers/umpire_states/umpire_state"

class LoadState < UmpireState
  def display_long_prompt
    puts "Saved games:"
    saved_games = GameSaver.get_list_of_saved_games
    saved_games.each do |game|
      puts " -- #{game[:id]}: #{game[:title]}"
    end
    puts
  end

  def display_prompt_sign
    print "Type game ID (or 'back' to return): "
  end

  def process_input(context, command)
    case command
    when "back"
      context.set_state(IntroState.new)
    else
      id = command.to_i
      game = GameSaver.load_game_by_id(id)
      if not game.nil?
        context.set_state(PlayState.new(game))
      else
        puts "Sorry, '#{command}' is not a valid game ID."
        puts
      end
    end
  end
end