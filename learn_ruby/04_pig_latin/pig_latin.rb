def translate(sentence)
	words = sentence.split(" ")
	translated_words = []
	words.each do |word|
		translated_words.push(translate_word(word))
	end
	translated_words.join(' ')
end

def translate_word(word)
	vowels = ["a", "e", "i", "o", "u"]
	suffix = "ay"
	if vowels.include?(word[0])
		return word + suffix
	else
		prefix = ""
		word.split('').each_with_index do |letter, index|
			is_consonant = (not vowels.include?(letter))
			is_qu = prefix[-1] == "q" and letter == "u"
			if is_consonant or is_qu
				prefix += letter
			else
				return word[prefix.length..-1] + prefix + suffix
			end
		end
		return prefix + suffix
	end
end