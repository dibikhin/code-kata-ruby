dictionary_file_name = ARGV[0]
# puts File.open(dictionary_file_name, 'r').read.lines.map { |word| word.strip.size }.uniq.sort
puts File.open(dictionary_file_name, 'r').read.lines
	.map{ |word| word.strip }.uniq
	.group_by{ |word| word.size }
	.map{ |k, v| {k => v.size} }
	.sort_by{ |k| k.keys }