def echo(say)
	say
end

def shout(say)
	say.upcase
end

def repeat(say, number_of_repetitions = 2)
	result = say
	(number_of_repetitions - 1).times do
		result += " #{say}"
	end
	result
end

def start_of_word(word, number_of_letters)
	word[0..(number_of_letters - 1)]
end

def first_word(sentence)
	sentence.split[0]
end

def titleize(words)
	words_list = words.split
	little_words = ["over", "the", "and"]
	words_list.each_with_index do |word, index|
		if ((not little_words.include?(word)) or index == 0)
			word.capitalize!
		end
	end
	words_list.join(' ')
end