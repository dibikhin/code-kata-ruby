require 'minitest/autorun'
require 'pp'
require 'set'

class Dependencies
	def initialize
		@all_deps = {}
	end
		
	def add_direct(key, deps)
		@all_deps[key] = deps
	end

	def dependencies_for(key)
		deps_chain = recur_deps_for(key, Set.new)
		(deps_chain - [key]).to_a.sort
	end

	def recur_deps_for(key, deps_chain)
		key_deps = @all_deps[key]
		return deps_chain if deps_chain.include?(key)
		deps_chain += [key]
		return deps_chain if key_deps.nil?
		key_deps.each { |dep| deps_chain += recur_deps_for(dep, deps_chain) }
		deps_chain
	end
end

class TestRack < Minitest::Test
	def test_basic
		dep = Dependencies.new

		dep.add_direct('A', %w{ B C } )
		dep.add_direct('B', %w{ C E } )
		dep.add_direct('C', %w{ G   } )
		dep.add_direct('D', %w{ A F } )
		dep.add_direct('E', %w{ F   } )
		dep.add_direct('F', %w{ H   } )

		assert_equal( %w{ B C E F G H },   dep.dependencies_for('A'))
		assert_equal( %w{ C E F G H },     dep.dependencies_for('B'))
		assert_equal( %w{ G },             dep.dependencies_for('C'))
		assert_equal( %w{ A B C E F G H }, dep.dependencies_for('D'))
		assert_equal( %w{ F H },           dep.dependencies_for('E'))
		assert_equal( %w{ H },             dep.dependencies_for('F'))
	end

	def test_simple_loop
		dep = Dependencies.new

		dep.add_direct('A', %w{ B } )
		dep.add_direct('B', %w{ X } )
		dep.add_direct('X', %w{ A } )
		
		assert_equal( %w{ B X }, dep.dependencies_for('A'))
		assert_equal( %w{ A X }, dep.dependencies_for('B'))
		assert_equal( %w{ A B }, dep.dependencies_for('X'))
	end

	def test_simple_loops_multi_deps
		dep = Dependencies.new

		dep.add_direct('A', %w{ B D } )
		dep.add_direct('B', %w{ X   } )
		dep.add_direct('X', %w{ A   } )
		dep.add_direct('D', %w{ E   } )
		
		assert_equal( %w{ B D E X }, dep.dependencies_for('A'))
		assert_equal( %w{ A D E X }, dep.dependencies_for('B'))
		assert_equal( %w{ A B D E }, dep.dependencies_for('X'))
	end

	def test_simple_loops_multi_deps_2
		dep = Dependencies.new

		dep.add_direct('A', %w{ B D } )
		dep.add_direct('B', %w{ X 	} )
		dep.add_direct('X', %w{ W B } )
		dep.add_direct('D', %w{ E 	} )
		
		assert_equal( %w{ B D E W X }, dep.dependencies_for('A'))
		assert_equal( %w{ W X       }, dep.dependencies_for('B'))
		assert_equal( %w{ B W       }, dep.dependencies_for('X'))
	end

	def test_simple_loops_multi_deps_3
		dep = Dependencies.new

		dep.add_direct('A', %w{ B D } )
		dep.add_direct('B', %w{ X 	} )
		dep.add_direct('X', %w{ A B } )
		dep.add_direct('D', %w{ E 	} )
		
		assert_equal( %w{ B D E X }, dep.dependencies_for('A'))
		assert_equal( %w{ A D E X }, dep.dependencies_for('B'))
		assert_equal( %w{ A B D E }, dep.dependencies_for('X'))
	end
end