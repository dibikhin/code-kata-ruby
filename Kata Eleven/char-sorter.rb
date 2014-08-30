class CharSorter
	def self.sort(str)
		index = {}
		('a'..'z').each { |chr| index[chr] = 0 }
		str.downcase!
		str.chars.each { |chr| index[chr] += 1 if !index[chr].nil?}
		sorted_chars = []
		index.each { |chr, count| sorted_chars << chr * count if count > 0 }
		sorted_chars * ''
	end
end