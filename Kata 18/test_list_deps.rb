require 'minitest/autorun'
require 'pp'

class Dependencies
	def initialize
		@all_deps = {}
	end
		
	def add_direct(key, deps)
		@all_deps[key] = deps
	end

	def dependencies_for(key)
		deps_chain = []
		deps_for_recur(key, deps_chain, key)
		deps_chain.uniq.sort
	end

	def deps_for_recur(key, deps_chain, starting_key)
		key_deps = @all_deps[key]
		return if key_deps.nil?
		return if key_deps.include?(starting_key)
		deps_chain += key_deps
		pp key, key_deps, deps_chain, starting_key
		key_deps.each do |dep| 
			deps_for_recur(dep, deps_chain, starting_key)
		end		
	end
end

class TestRack < Minitest::Test
	def test_basic
		# dep = Dependencies.new
		# dep.add_direct('A', %w{ B C } )
		# dep.add_direct('B', %w{ C E } )
		# dep.add_direct('C', %w{ G   } )
		# dep.add_direct('D', %w{ A F } )
		# dep.add_direct('E', %w{ F   } )
		# dep.add_direct('F', %w{ H   } )

		# assert_equal( %w{ B C E F G H },   dep.dependencies_for('A'))
		# assert_equal( %w{ C E F G H },     dep.dependencies_for('B'))
		# assert_equal( %w{ G },             dep.dependencies_for('C'))
		# assert_equal( %w{ A B C E F G H }, dep.dependencies_for('D'))
		# assert_equal( %w{ F H },           dep.dependencies_for('E'))
		# assert_equal( %w{ H },             dep.dependencies_for('F'))

		dep = Dependencies.new

		dep.add_direct('A', %w{ B } )
		dep.add_direct('B', %w{ X } )
		dep.add_direct('X', %w{ A } )
		
		assert_equal( %w{ B X }, dep.dependencies_for('A'))
		#assert_equal( %w{ A X }, dep.dependencies_for('B'))
		#assert_equal( %w{ A B }, dep.dependencies_for('X'))
	end
end