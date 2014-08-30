require 'minitest/autorun'
require '.\char-sorter'

class TestRack < Minitest::Test
	def test_sort
		expected = 'aaaaabbbbcccdeeeeeghhhiiiiklllllllmnnnnooopprsssstttuuvwyyyy'
		str = 'When not studying nuclear physics, Bambi likes to play beach volleyball.'
		assert_equal(expected, CharSorter.sort(str))		
	end
end