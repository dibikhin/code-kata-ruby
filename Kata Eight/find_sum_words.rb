require 'pp'
require 'set'
require 'ruby-prof'

def	read_dictionary(dictionary_file_name)
	File.open(dictionary_file_name, 'r').read.lines.map { |word| word.strip }.uniq
end

def find_compositions(words)
	counter = 1
	compositions = {}
	words_set = Set.new(words)
	RubyProf.start
	words.combination(2).each do |comb|
		counter += 2
		left_right = comb[0] + comb[1]
		right_left = comb[1] + comb[0]
		compositions[left_right] = comb if words_set.include?(left_right)
		compositions[right_left] = comb if words_set.include?(right_left)
	end
	puts RubyProf::FlatPrinter.new(RubyProf.stop).print(STDOUT)
	puts counter
	compositions
end

dictionary_file_name = ARGV[0]
start_time = Time.now

words = read_dictionary(dictionary_file_name)
pp find_compositions(words.first(1000))

puts Time.now - start_time