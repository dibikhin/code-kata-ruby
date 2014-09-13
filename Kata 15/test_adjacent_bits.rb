require 'minitest/autorun'
require 'pp'

def find_adjacent_bits(bit_count)
	adjacent_bits_nums = []
	(0..(2 ** bit_count - 1)).each do |num| 
		(0..(bit_count - 2)).each do |shift|
			adjacent_bits_nums << num if num == 0b11 << shift
		end
	end
	adjacent_bits_nums
end

class TestRack < Minitest::Test
	def test_three_digit_bins
		assert_equal([0b011, 0b110], find_adjacent_bits(3))
	end
	
	def test_four_digit_bins
		assert_equal([0b0011, 0b0110, 0b1100], find_adjacent_bits(4))
	end
end