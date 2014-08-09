require 'multi_json'
#require 'murmurhash3'
require '.\digestfnv'

class BloomFilter
	class BitMap
		def initialize(file_name = nil)
			if file_name.nil?
				@bitmap = {}
				('a'..'z').each do |chr| 
					@bitmap[chr] = {} 
					(1..22).each do |num|
						@bitmap[chr][num] = 0
					end
				end
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
				bitmap.add(word_hash, word.size, word[0].downcase)
				counter += 1
			end
			puts counter
			puts Time.now
			bitmap
		end
		
		# @bitmap & word_hash looks like ???
		def add(word_hash, word_size, first_letter)
			@bitmap[first_letter][word_size] = @bitmap[first_letter][word_size] | word_hash
		end

		def contains?(word_hash, word_size, first_letter)
			word_size = word_size.to_s # due to deserialization issue			
			@bitmap[first_letter][word_size] == @bitmap[first_letter][word_size] | word_hash
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
	def self.compute_hash(str)
		#MurmurHash3::V128.str_hash(str)
		Digest::FNV.calculate(str, 1024)
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
		bitmap.contains?(word_hash, word.size, word[0])
	end
end