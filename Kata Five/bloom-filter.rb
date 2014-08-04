class BloomFilter
	class BitMap
		def initialize(file_name = nil)
		end	

		def self.compute(words)
			bitmap = BitMap.new
			words.each do |word|
				word_hash = compute_hash(word)
				bitmap.add(word_hash)
			end
			bitmap
		end
	
		def load(file_name)
		end

		def save(file_name)
		end

		def contains?(word_hash)
			true
		end
	end

	# private
	def self.compute_hash(word)
	end

	def load_dictionary(dictionary_file_name)
		File.open(dictionary_file_name, 'r').read.lines.map{ |line| line.strip }
	end

	# public

	def self.refresh_bitmap(dictionary_file_name, bitmap_file_name)
		words = load_dictionary(dictionary_file_name)
		bitmap = BitMap.compute(words)
		bitmap.save(bitmap_file_name)
	end

	def self.check_word(word, bitmap_file_name)
		bitmap = BitMap.new(bitmap_file_name)
		word_hash = compute_hash(word)
		bitmap.contains?(word_hash)
	end
end