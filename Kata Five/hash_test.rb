require 'pp'

dictionary_file_name = ARGV[0]

pre_anagrams = {}
hashes = []
words = File.open(dictionary_file_name, 'r').read.lines
words.each do |word|
	stripped_word = word.strip
	sorted_chars = stripped_word.downcase.chars.sort * ''
	#pre_anagrams[sorted_chars] = {}	if pre_anagrams[sorted_chars].nil?
	#pre_anagrams[sorted_chars][:word] = stripped_word
	hash = stripped_word.bytes.reduce(:+)
	#pre_anagrams[sorted_chars][:hash] = hash
	hashes << hash
end

#pp pre_anagrams.sort_by { |_, v| v.size } #.to_a.last(5)

pp hashes.uniq.sort.size