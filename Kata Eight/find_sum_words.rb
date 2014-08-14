require 'pp'

def	read_dictionary(dictionary_file_name)
	File.open(dictionary_file_name, 'r').read.lines.uniq.map { |word| word.strip }
end

# con + vex => convex
# here + by => hereby
def make_composition(one, another)
	{ (one + another) => [one, another] }
end

def find_compositions(words)
	counter = 1
	compositions = []
	words.each do |first_word|
		words.each do |second_word|
			counter =+ counter + 1
			compositions << make_composition(first_word, second_word) if words.include?(first_word + second_word)
		end
	end
	puts counter
	compositions
end

puts Time.now
dictionary_file_name = ARGV[0]
words = read_dictionary(dictionary_file_name)
pp find_compositions(words)
puts Time.now