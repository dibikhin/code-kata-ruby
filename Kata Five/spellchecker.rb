require '.\bloom-filter'

word, bitmap_file_name = ARGV[0], ARGV[1]

puts BloomFilter.check_word(word, bitmap_file_name)