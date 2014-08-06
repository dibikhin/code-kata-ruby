require '.\bloom-filter'

dictionary_file_name, bitmap_file_name = ARGV[0], ARGV[1]
BloomFilter.refresh_bitmap(dictionary_file_name, bitmap_file_name)
