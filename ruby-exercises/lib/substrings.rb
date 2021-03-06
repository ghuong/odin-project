def substrings(sentence, dictionary)
  dict_hash = Hash.new(0)
  for word in dictionary
    for i in 0..sentence.length-word.length
      if word.downcase == sentence[i...i+word.length].downcase
        dict_hash[word] += 1
      end
    end
  end
  return dict_hash
end
