class Book
	attr_reader :title
	ARTICLES = ["an", "a", "the"]
	CONJUNCTIONS = ["and"]
	PREPOSITIONS = ["in", "of"]

	def title=(title)
		words = title.split
		words.each_with_index do |word, index|
			word_is_little = (ARTICLES.include?(word) or
				CONJUNCTIONS.include?(word) or
				PREPOSITIONS.include?(word))
			if ((not word_is_little) or index == 0)
				word.capitalize!
			end
		end
		@title = words.join(' ')
	end
end
