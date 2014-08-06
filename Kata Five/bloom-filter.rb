require 'multi_json'
require 'murmurhash3'

class BloomFilter
	class BitMap
		def initialize(file_name = nil)
			if file_name.nil?
				@bitmap = [0, 0, 0, 0]
			else
				@bitmap = load(file_name)
			end
		end	

		def self.compute(words)
			bitmap = BitMap.new
			puts Time.now
			counter = 0
			words.each do |word|
				word_hash = BloomFilter.compute_hash(word)
				bitmap.add(word_hash)
				counter += 1
			end
			puts counter
			puts Time.now
			bitmap
		end
		
		# @bitmap & word_hash looks like [4032114320, 1250832429, 498664707, 611468556]
		def add(word_hash)
			@bitmap[0] = @bitmap[0] | word_hash[0]
			@bitmap[1] = @bitmap[1] | word_hash[1]
			@bitmap[2] = @bitmap[2] | word_hash[2]
			@bitmap[3] = @bitmap[3] | word_hash[3]
		end

		def contains?(word_hash)
			@bitmap[0] == @bitmap[0] | word_hash[0]
			@bitmap[1] == @bitmap[1] | word_hash[1]
			@bitmap[2] == @bitmap[2] | word_hash[2]
			@bitmap[3] == @bitmap[3] | word_hash[3]
		end
	
		def load(file_name)
			@bitmap = MultiJson.load(File.open(file_name, 'r').read)
		end

		def save(file_name)
			File.open(file_name, 'w') do |file| 
				file.write(MultiJson.dump(@bitmap))
			end
		end
	end

	# private
	def self.compute_hash(word)
		MurmurHash3::V128.str_hash(word)
	end

	def self.load_dictionary(dictionary_file_name)
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