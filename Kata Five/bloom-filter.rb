require 'multi_json'
# require 'murmurhash3'
require '.\digestfnv'

class BloomFilter
	class BitMap
		def initialize(file_name = nil)
			if file_name.nil?
				@bitmap = {}
				(2..22).each do |size| 
					@bitmap[size] = 0 					
				end
				# @bitmap = {}
				# ('a'..'z').each do |chr| 
					# @bitmap[chr] = {} 
					# (2..22).each do |num|
						# @bitmap[chr][num] = [0, 0, 0, 0]
					# end
				# end
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
				bitmap.add(word_hash, word.size, word[0])
				counter += 1
			end
			puts counter
			puts Time.now
			bitmap
		end
		
		# @bitmap & word_hash looks like ???
		def add(word_hash, word_size, first_letter)	
			@bitmap[word_size] = @bitmap[word_size] | word_hash
			# (0..3).each do |ix| 
				# @bitmap[first_letter][word_size][ix] = @bitmap[first_letter][word_size][ix] | word_hash[ix]
			# end
			# #ix = (word_size % 4) - 1
			# # @bitmap[first_letter][ix] = @bitmap[first_letter][ix] | word_hash[ix]
			# # # @bitmap[ix] = @bitmap[ix] | word_hash[ix]
			# # # #@bitmap[0] = @bitmap[0] | word_hash[0]
			# # # #@bitmap[1] = @bitmap[1] | word_hash[1]
			# # # #@bitmap[2] = @bitmap[2] | word_hash[2]
			# # # #@bitmap[3] = @bitmap[3] | word_hash[3]
		end

		def contains?(word_hash, word_size, first_letter)
			word_size = word_size.to_s # due to deserialization issue
			@bitmap[word_size] == @bitmap[word_size] | word_hash
			# word_size = word_size.to_s # due to deserialization issue
			# contains = false
			# (0..3).each do |ix| 				
				# contains = @bitmap[first_letter][word_size][ix] == @bitmap[first_letter][word_size][ix] | word_hash[ix]
			# end
			# contains
			# # ix = (word_size % 4) - 1
			# # @bitmap[first_letter][ix] == @bitmap[first_letter][ix] | word_hash[ix]
			# # # @bitmap[ix] == @bitmap[ix] | word_hash[ix]
			# # # #@bitmap[0] == @bitmap[0] | word_hash[0] &&
			# # # #@bitmap[1] == @bitmap[1] | word_hash[1] &&
			# # # #@bitmap[2] == @bitmap[2] | word_hash[2] &&
			# # # #@bitmap[3] == @bitmap[3] | word_hash[3] &&
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
		# MurmurHash3::V128.str_hash(str)
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