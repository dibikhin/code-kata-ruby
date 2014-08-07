dictionary_file_name = ARGV[0]

puts File.open(dictionary_file_name, 'r').read.lines.map{ |line| line.strip.size }.uniq.sort