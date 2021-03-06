NUM_CHARS_IN_ALPHABET = 26

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
  puts ciphertext
end
