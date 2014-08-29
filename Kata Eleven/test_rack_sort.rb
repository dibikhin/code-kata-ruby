require 'minitest/autorun'
require '.\my-rack'

class TestRack < Minitest::Test
	def test_sort
		rack = Rack.new
		assert_equal([], rack.balls)
		rack.add(20)
		assert_equal([ 20 ], rack.balls)
		rack.add(10)
		assert_equal([ 10, 20 ], rack.balls)
		rack.add(30)
		assert_equal([ 10, 20, 30 ], rack.balls)
	end
end