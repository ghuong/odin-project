require "controllers/umpire_states/umpire_state"
require "controllers/umpire_states/intro_state"
require "controllers/umpire_states/save_state"
require "views/display"

class PlayState < UmpireState
  def initialize(game)
    @game = game
  end

  def display_intro
    puts "New game started."
    puts
  end

  def display_long_prompt
    Display.display_game(@game)
    puts
    puts "Type 'quit' anytime to return to menu, or 'save' to save game."
    puts "Submit moves like '2d 4d'; to castle, type 'castle left' or 'castle right'"
    puts
  end

  def display_short_prompt
    Display.display_game(@game)
    puts
  end

  def display_prompt_sign
    color = @game.get_current_player == :white ? "White" : "Black"
    print "#{color} players turn: "
  end

  def process_input(context, command)
    case command
    when "quit"
      context.set_state(IntroState.new)
    when "save"
      context.set_state(SaveState.new(self))
    when "castle left"
      process_castle(:left)
    when "castle right"
      process_castle(:right)
    else
      process_move(context, command)
    end
  end

  def process_move(context, command)
    coords = command.gsub(/[\s,]+/, "")
    if coords.length != 4
      puts "Sorry, that input was invalid."
      puts
      return
    end

    start_row, start_col, destination_row, destination_col = coords[0], coords[1], coords[2], coords[3]
    if @game.can_move?(start_row, start_col, destination_row, destination_col)
      @game.move(start_row, start_col, destination_row, destination_col)
      if @game.is_pawn_promotion?(destination_row, destination_col)
        Display.display_game(@game)
        puts
        promote_pawn(destination_row, destination_col)
      end

      if @game.checkmate? ChessGame.get_enemy_color(@game.get_current_player)
        Display.display_game(@game)
        puts
        return @game.get_current_player.to_s
      end
      return
    else
      puts "Sorry, that move is invalid."
      puts
    end
  end

  def process_castle(direction)
    if @game.can_castle?(direction)
      @game.castle(direction)
    else
      puts "You cannot castle."
      puts
    end
  end

  def promote_pawn(row, col)
    puts "What do you want to promote your pawn to?"
    print " > "
    type = gets.chomp.downcase.to_sym
    puts
    @game.promote_pawn(row, col, type)
  end

  # For testing
  def get_game
    @game
  end
end