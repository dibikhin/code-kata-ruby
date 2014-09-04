require 'pp'

def split_and_clear_text(txt)
	#%w(I wish I may I wish I might)
	txt.split
end

def load_text(file_name)
	File.open(file_name, 'r').read	
end

def find_trigrams(txt)
	word_list = split_and_clear_text(txt)
	trigrams, i = {}, 0
	word_list.each do |first_word|
		second_word, third_word = word_list[i + 1], word_list[i + 2]
		break if second_word.nil? || third_word.nil?
		if trigrams[[first_word, second_word]].nil?
			trigrams[[first_word, second_word]] = [third_word]
		else
			trigrams[[first_word, second_word]] += [third_word]
		end
		i += 1
	end 
	trigrams
end

def compose_story_recur(trigrams, current_key, new_story, depth, max_depth)
	depth += 1
	return new_story if depth > max_depth
	trigram_values = trigrams[current_key]
	value_pos = trigram_values.size > 1 ? Random.new.rand(trigram_values.size - 1) : 0
	new_story << "%s " % [trigram_values[value_pos]]
	# new_story << "%s %s %s " % [current_key[0], current_key[1], trigram_values[0]]
	compose_story_recur(trigrams, [current_key[1], trigram_values[0]], new_story, depth, max_depth)
end

def compose_story(trigrams, max_depth = 10)
	# pp trigrams
	trigrams.select { |k, v| !v.nil? }
	new_story, depth = '', 0
	starting_key = trigrams.keys[Random.new.rand(trigrams.keys.size - 1)]
	compose_story_recur(trigrams, starting_key, new_story, depth, max_depth)
	new_story
end

max_depth = ARGV[0].to_i
text_file_name = ARGV[1]

txt = load_text(text_file_name)
trigrams = find_trigrams(txt)
puts compose_story(trigrams, max_depth)