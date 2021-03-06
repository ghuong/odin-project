require "controllers/umpire_states/umpire_state"

class SaveState < UmpireState
  def initialize(current_play_state)
    @current_play_state = current_play_state
  end

  def display_prompt_sign
    print "Enter a name for your game: "
  end

  def process_input(context, game_title)
    game = @current_play_state.get_game
    GameSaver.save_game(game.id, game_title, game)
    context.set_state(@current_play_state)
    puts "Your game '#{game_title}' has been saved!"
  end
end