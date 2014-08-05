require '.\bloom-filter'

#word, bitmap_file_name = ARGV[0], ARGV[1]
#puts BloomFilter.check_word(word, bitmap_file_name)

dictionary_file_name, bitmap_file_name = ARGV[0], ARGV[1]
BloomFilter.refresh_bitmap(dictionary_file_name, bitmap_file_name)