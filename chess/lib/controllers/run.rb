require "controllers/umpire_states/umpire_context"

# Run the whole game
def run
  umpire_context = UmpireContext.new
  loop do
    umpire_context.display_prompt
    input = gets.chomp.downcase
    puts
    result = umpire_context.process_input(input)
    case result
    when "quit"
      break
    when "white"
      puts "Checkmate! White wins!"
      break
    when "black"
      puts "Checkmate! Black wins!"
      break
    end
  end

  puts
  puts "Thanks for playing!"
end