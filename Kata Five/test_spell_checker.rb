require '.\bloom-filter'

dictionary_file_name, bitmap_file_name = ARGV[0], ARGV[1]

counter = 0

File.open(dictionary_file_name, 'r').read.lines.map{ |line| line.strip }.each do |word|
	counter +=1 if BloomFilter.check_word(word, bitmap_file_name)	
end

puts counter