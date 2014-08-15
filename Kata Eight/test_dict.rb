dictionary_file_name = ARGV[0]
puts File.open(dictionary_file_name, 'r').read.lines.uniq.map { |word| word.strip.size }.uniq.sort