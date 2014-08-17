require 'pp'
require 'ruby-prof'

def	read_dictionary(dictionary_file_name)
	File.open(dictionary_file_name, 'r').read.lines.map { |word| word.strip }.uniq
end

# con + vex => convex
# here + by => hereby
def add_composition(permutation, compositions)
	compositions[permutation[0] + permutation[1]] = permutation
end

def find_compositions(words)
	counter = 1
	compositions = {}
	# words.select{ |word| word.size <= 5 }.each do |first_word|
		# words.select{ |word| word.size <= 5 }.each do |second_word|
			# counter =+ counter + 1
			# add_composition(first_word, second_word, compositions) if words.include?(first_word + second_word)
		# end
	# end
	RubyProf.start
	short_words = words.select{ |word| word.size <= 5 }
	long_words = words.select{ |word| word.size >= 5 }
	short_words.combination(2).each do |perm|
		counter =+ counter + 1
		left_right = perm[0] + perm[1]
		right_left = perm[1] + perm[0]
		add_composition(perm, compositions) if long_words.any? { |word| word == left_right || word == right_left }
	end
	puts RubyProf::FlatPrinter.new(RubyProf.stop).print(STDOUT)
	puts counter
	compositions
end

puts Time.now
dictionary_file_name = ARGV[0]

words = read_dictionary(dictionary_file_name)
pp find_compositions(words.first(500))

puts Time.now

# {1=>2}
# {2=>23}
# {3=>72}
# {4=>138}
# {5=>92}
# {6=>58}
# {7=>37}
# {8=>18}
# {9=>10}
# {10=>6}
# {11=>2}
# {12=>1}
# {13=>1}

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