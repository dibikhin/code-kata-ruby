require 'pp'

dictionary_file_name = ARGV[0]

sum_words = []
words = File.open(dictionary_file_name, 'r').read.lines.uniq.map { |w| w.strip }
words.each do |word|
	words.each do |a_word|			
		if words.include?(word + a_word)
			sum_words << { (word + a_word) => [word, a_word] } 
		end
	end
end

pp sum_words