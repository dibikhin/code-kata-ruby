require 'pp'

def	read_dictionary(dictionary_file_name)
	File.open(dictionary_file_name, 'r').read.lines.uniq.map { |word| word.strip }
end

# con + vex => convex
# here + by => hereby
def add_composition(one, another, compositions)
	compositions[one + another] = [one, another]
end

def find_compositions(words)
	counter = 1
	compositions = {}
	words.each do |first_word|
		words.each do |second_word|
			counter =+ counter + 1
			add_composition(first_word, second_word, compositions) if words.include?(first_word + second_word)
		end
	end
	puts counter
	compositions
end

puts Time.now
dictionary_file_name = ARGV[0]
words = read_dictionary(dictionary_file_name)
pp find_compositions(words) #.sort_by { |k, v| v }
puts Time.now

# [["ago", 3],
 # ["into", 4],
 # ["away", 4],
 # ["door", 4],
 # ["some", 4],
 # ["along", 5],
 # ["heart", 5],
 # ["maybe", 5],
 # ["today", 5],
 # ["become", 6],
 # ["within", 6],
 # ["without", 7],
 # ["someone", 7],
 # ["however", 7],
 # ["nothing", 7],
 # ["anything", 8],
 # ["something", 9],
 # ["everything", 10],
 # ["understand", 10]]