require 'pp'

dictionary_file_name = ARGV[0]

pre_anagrams = {}
words = File.open(dictionary_file_name, 'r').read.lines.map{ |line| line.strip }
words.each do |word|
	sorted_chars = word.downcase.chars.sort * ''
	pre_anagrams[sorted_chars] = []	if pre_anagrams[sorted_chars].nil?
	pre_anagrams[sorted_chars] << word
end

pp pre_anagrams.sort_by { |_, v| v.size }