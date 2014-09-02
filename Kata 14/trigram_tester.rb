require 'pp'

def split_and_clear_text(txt)
	%w(I wish I may I wish I might)
end

def load_text(file_name)
	# File.open(file_name, 'r').read
	""
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

def compose_story(trigrams)
	pp trigrams
end

txt = load_text('story.txt')
trigrams = find_trigrams(txt)
compose_story(trigrams)