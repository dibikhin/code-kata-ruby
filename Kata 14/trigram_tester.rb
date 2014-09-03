require 'pp'

def split_and_clear_text(txt)
#	%w(I wish I may I wish I might)
	txt.split
end

def load_text(file_name)
	File.open(file_name, 'r').read	
end

def find_trigrams(txt)
	word_list = split_and_clear_text(txt)
	trigrams, i = {}, 0
	word_list.each do |word| 
		if trigrams[[word, word_list[i + 1]]].nil?
			trigrams[[word, word_list[i + 1]]] = [word_list[i + 2]]
		else
			trigrams[[word, word_list[i + 1]]] += [word_list[i + 2]]
		end
		i += 1
	end 
	trigrams
end

def compose_story_recur(trigrams, new_story, depth, max_depth)
	return new_story if depth > max_depth
end

def compose_story(trigrams)
	# pp trigrams
	new_story, depth, max_depth = '', 0, 10
	compose_story_recur(trigrams, new_story, depth, max_depth)
	new_story
end

txt = load_text('sample.txt')
trigrams = find_trigrams(txt)
compose_story(trigrams)