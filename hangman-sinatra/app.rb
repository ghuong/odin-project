require 'sinatra'
require 'sinatra/reloader' if development?

require_relative 'hangman'

hangman = HangmanGameState.new

get '/' do
  letter = (params['letter'] or '')
  result = ''
  if letter
    if hangman.guess_letter(letter)
      result = "You guessed right!"
    else
      result = "You guessed wrong!"
    end
  end
  status = hangman.display_game_status
  erb :index, :locals => {:status => status, :result => result}
end