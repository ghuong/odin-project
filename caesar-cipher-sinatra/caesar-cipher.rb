require 'sinatra'
require 'sinatra/reloader' if development?

NUM_CHARS_IN_ALPHABET = 26

get '/' do
  cleartext = (params['cleartext'] or "")
  shift = (params['shift'].to_i or 0)
  ciphertext = caesar_cipher(cleartext, shift)
  erb :index , :locals => {:ciphertext => ciphertext}
end

def caesar_cipher(cleartext, shift)
  ciphertext = ""
  cleartext.each_char do |char|
    if 'A' <= char and char <= 'Z'
      alpha = 'A'.ord
    elsif 'a' <= char and char <= 'z'
      alpha = 'a'.ord
    else
      ciphertext += char
      next
    end
    char_ord = ((char.ord - alpha + shift) % NUM_CHARS_IN_ALPHABET) + alpha
    ciphertext += char_ord.chr
  end
  return ciphertext
end
