require 'multi_json'
#require 'murmurhash3'
#require '.\digestfnv'

class BloomFilter
	class BitMap
		def initialize(file_name = nil)
			if file_name.nil?
				@bitmap = {}
				('a'..'z').each do |chr| 
					@bitmap[chr] = {} 
					(0..25).each do |num|
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
			('a'..'z').each do |chr|					
				(0..25).each do |pos|
					@bitmap[chr][pos] = word_hash[chr][pos]
				end
			end
		end

		def contains?(word_hash, word_size, first_letter)
			res = []
			('a'..'z').each do |chr|					
				(0..25).each do |pos|
					res[pos] = @bitmap[chr][pos.to_s] == word_hash[chr][pos]
				end
			end
			res.all? { |res| res == true }
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
		#Digest::FNV.calculate(str, 1024)
		hash = {}
		('a'..'z').each do |chr| 
			hash[chr] = {} 
			(0..25).each do |pos|
				hash[chr][pos] = 0
			end
		end
		pos = 0	
		str.each_char{ |chr| hash[chr][pos] = 1; pos += 1; }
		hash
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