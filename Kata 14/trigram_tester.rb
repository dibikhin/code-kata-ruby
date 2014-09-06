require 'pp'

def split_and_clear_text(txt)
	# %w(I wish I may I wish I might)
	#txt.scan(/\w+/).map { |word| word.downcase }
	txt.gsub(/[,;\"\:]/,'').gsub(/--/,' ').split(/\s/)
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
	trigram_values = trigrams[current_key]
	return new_story if depth > max_depth || trigram_values.nil?
	third_word = trigram_values[0]
	new_story << "%s " % [third_word]
	trigram_values.delete_at(trigram_values.index(third_word))
	if trigram_values.empty?
		trigrams.delete(current_key)
	else
		trigrams[current_key] = trigram_values
	end
	depth += 1
	compose_story_recur(trigrams, [current_key[1], third_word], new_story, depth, max_depth)
end

def init_story(trigrams)
	rand_key_ix = Random.new.rand(trigrams.keys.size)
	starting_key = trigrams.keys[rand_key_ix]
	new_story = ''
	new_story << "%s %s %s " % [starting_key[0], starting_key[1], starting_key[2]]
	return starting_key, new_story
end

def compose_story(trigrams, max_depth = 10)
	new_story, depth = '', 0
	starting_key, new_story = init_story(trigrams) 
	compose_story_recur(trigrams, starting_key, new_story, depth, max_depth)
	new_story
end

max_depth = ARGV[0].to_i
text_file_name = ARGV[1]

txt = load_text(text_file_name)
trigrams = find_trigrams(txt)
puts compose_story(trigrams, max_depth)