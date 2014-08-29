class Rack
	def initialize
		@balls = {}
		(0..59).each { |n| @balls[n] = false }
	end

	def add(ball_number)
		@balls[ball_number] = true
	end
	
	def balls
		balls = []
		@balls.map { |k, v| balls << k if v == true }
		balls
	end
end