require "controllers/umpire_states/umpire_state"
require "controllers/umpire_states/load_state"
require "controllers/umpire_states/play_state"

class IntroState < UmpireState
  def initialize
    super
    @not_exist_any_saves = not(UmpireHelpers.exist_any_saves?)
  end

  def display_intro
    puts "Welcome to Chess!"
    puts
  end

  def display_long_prompt
    puts "Commands:"
    puts " -- new (Starts a new game)"
    puts " -- load (Load saved games)" unless @not_exist_any_saves
    puts " -- quit (Quit the program)"
    puts
  end

  def display_short_prompt
    print "Commands: new, "
    print "load, " unless @not_exist_any_saves
    print "quit\n"
    puts
  end

  def process_input(context, command)
    case command
    when "new"
      transition_to_new_game_state(context)
    when "load"
      if @not_exist_any_saves
        UmpireHelpers.display_invalid_command_warning
      else
        context.set_state(LoadState.new)
      end
    when "quit"
      return "quit"
    else
      super(context, command)
    end
  end

  def transition_to_new_game_state(context)
    context.set_state(PlayState.new(UmpireHelpers.get_new_game))
  end
end